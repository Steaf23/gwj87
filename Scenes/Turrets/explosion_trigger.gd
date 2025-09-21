class_name ExplosionTrigger
extends Node

@export var turret: Turret
@export var damage_area: DamageArea
@export var single_target: bool = false
@export var explode_turret: bool = true
@onready var startup_timer: Timer = $StartupTimer

var exploded: bool = false

func _ready() -> void:
	assert(turret and damage_area, "This trigger requires a turret and damage area to function")
	
	startup_timer.start()
	turret.get_node("VisionRange/CollisionShape2D").disabled = true
	
	turret.target_changed.connect(func(t): if t: 
		explode(t)
		)
	
func explode(target: Enemy = null) -> void:
	if exploded:
		return
		
	if explode_turret:
		exploded = true
	
	if not target or not single_target:
		damage_area.trigger()
	else:
		target.take_damage(damage_area.damage, damage_area.effect)
	
	SoundManager.play_random_sfx(Sounds.MUSHROOM_EXPLODE, 0.7)
	if explode_turret:
		turret.damage(turret.hp)


func _on_startup_timer_timeout() -> void:
	turret.get_node("VisionRange/CollisionShape2D").disabled = false
