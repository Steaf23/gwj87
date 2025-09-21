class_name Enemy
extends CharacterBody2D

enum DAMAGE_EFFECT {
	NONE,
	STUN,
}

signal died()
signal attack_started(attack_duration: float)

@export var damage: int = 1
@export var aoe: bool = false

@onready var ai_controller: AIController = $AIController
@onready var attack_cooldown: Timer = %AttackCooldown
@onready var hit_box: Area2D = $HitBox

var attacking: bool = false
var stunned: bool = false

var is_dead: bool = false

func _physics_process(_delta: float) -> void:
	if not attacking and not stunned:
		velocity = ai_controller.desired_velocity
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	if get_real_velocity().x < -0.1:
		flip_sprite(true)
	elif get_real_velocity().x > 0.1:
		flip_sprite(false)


func flip_sprite(flip: bool) -> void:
	var val = -1.0 if flip else 1.0
	$Sprite2D.scale.x = val
	hit_box.scale.x = val


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Turret and attack_cooldown.is_stopped() and not stunned:
		attack_cooldown.start()
		
		var body_pos = body.global_position
		await get_tree().create_timer($%AttackCooldown.wait_time * 0.3).timeout
		
		if aoe:
			for b in $HitBox.get_overlapping_bodies().filter(func(c): return c is Turret):
				if b == body: continue
				b.damage(damage / 2.0)
				if b.type == Turret.TURRET_TYPE.ELDER:
					take_damage(2)
		
		# if it didn't die from the other damage
		if is_instance_valid(body):
			body.damage(damage)
			if body.type == Turret.TURRET_TYPE.ELDER:
				take_damage(30)
		attack_started.emit($%AttackCooldown.wait_time * 0.7)
		
		
		flip_sprite(body_pos.x < global_position.x)
		$Sprite2D.play("swing")
		$HitBox/CollisionShape2D.set_deferred("disabled", true)
		attacking = true
		await get_tree().create_timer($%AttackCooldown.wait_time * 0.7).timeout
		attacking = false
		$Sprite2D.play("walk")


func _on_attack_cooldown_timeout() -> void:
	$HitBox/CollisionShape2D.disabled = false
	for b in $HitBox.get_overlapping_bodies():
		_on_hit_box_body_entered(b)


func take_damage(_amount: int, damage_effect: DAMAGE_EFFECT = DAMAGE_EFFECT.NONE) -> void:
	$HPBar.current_hp -= _amount
	
	if $HPBar.current_hp <= 0:
		is_dead = true
		died.emit()
		SoundManager.play_sfx(Sounds.ENEMY_DEATH, 0.2, randf_range(1.2, 0.8))
		queue_free()
		return
		
	SoundManager.play_sfx(Sounds.ENEMY_HIT, 0.1)
	
	match damage_effect:
		DAMAGE_EFFECT.STUN:
			$StunTimer.start()
			stunned = true
			$StunSprite.show()
			$Sprite2D.pause()


func _on_stun_timer_timeout() -> void:
	stunned = false
	$StunSprite.hide()
	$Sprite2D.play()
	for b in $HitBox.get_overlapping_bodies():
		_on_hit_box_body_entered(b)


func _on_hurtbox_damaged(amount: int, effect: Enemy.DAMAGE_EFFECT) -> void:
	take_damage(amount, effect)
