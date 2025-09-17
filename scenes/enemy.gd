class_name Enemy
extends CharacterBody2D

enum DAMAGE_EFFECT {
	NONE,
	STUN,
}

@export var damage: int = 1

@onready var ai_controller: AIController = $AIController
@onready var attack_cooldown: Timer = %AttackCooldown

var attacking: bool = false
var stunned: bool = false


func _physics_process(_delta: float) -> void:
	if not attacking and not stunned:
		velocity = ai_controller.desired_velocity
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Turret and attack_cooldown.is_stopped() and not stunned:
		attack_cooldown.start()
		body.damage(damage)
		$Sprite2D.play("swing")
		$HitBox/CollisionShape2D.set_deferred("disabled", true)
		attacking = true
		await get_tree().create_timer($%AttackCooldown.wait_time / 2).timeout
		attacking = false
		$Sprite2D.play("walk")


func _on_attack_cooldown_timeout() -> void:
	$HitBox/CollisionShape2D.disabled = false
	for b in $HitBox.get_overlapping_bodies():
		_on_hit_box_body_entered(b)


func take_damage(_amount: int, damage_effect: DAMAGE_EFFECT = DAMAGE_EFFECT.NONE) -> void:
	$HPBar.current_hp -= _amount
	
	if $HPBar.current_hp <= 0:
		queue_free()
		return
		
	match damage_effect:
		DAMAGE_EFFECT.STUN:
			$StunTimer.start()
			stunned = true


func _on_stun_timer_timeout() -> void:
	stunned = false
	for b in $HitBox.get_overlapping_bodies():
		_on_hit_box_body_entered(b)
