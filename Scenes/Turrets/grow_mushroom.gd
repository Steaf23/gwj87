class_name GrowMushroom
extends Turret

@onready var grow_stage: GrowStageAnimator = $GrowController/GrowStage
@onready var damage_area: DamageArea = %DamageArea


func _ready() -> void:
	update_stage()
	
	%ProgressBar.max_value = %GrowTimer.wait_time
	
	world.enemy_spawner.wave_cleared.connect(_on_wave_cleared)


func damage(_amount: int) -> void:
	if hp <= 0:
		return
	
	hp = clamp(hp - _amount, 0, max_hp)
	if hp <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
	SoundManager.play_random_sfx(Sounds.MUSHROOM_EXPLODE, 0.5)
	%GrowTimer.start()
	explode_head(hp + 1)
	

func explode_head(head: int) -> void:
	var explosion = preload("res://Scenes/Turrets/blue_explosion.tscn").instantiate()
	$HeadPositions.get_node(str(head)).add_child(explosion)
	
	await get_tree().create_timer(0.3).timeout
	
	damage_area.trigger()
	update_stage()
	


func _process(_delta: float) -> void:
	%ProgressBar.value = %GrowTimer.wait_time - %GrowTimer.time_left


func update_stage() -> void:
	grow_stage.set_stage(hp)
	%ProgressBar.visible = hp != max_hp


func _on_wave_cleared() -> void:
	hp = max_hp
	update_stage()


func _on_grow_timer_timeout() -> void:
	hp = clamp(hp + 1, 0, max_hp)
	if $CollisionShape2D.disabled:
		$CollisionShape2D.set_deferred("disabled", false)
	if hp != max_hp:
		%GrowTimer.start()
	update_stage()
