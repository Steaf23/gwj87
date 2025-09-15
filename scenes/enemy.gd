class_name Enemy
extends CharacterBody2D

@export var damage: int = 1

@onready var ai_controller: AIController = $AIController
@onready var attack_cooldown: Timer = %AttackCooldown


func _physics_process(delta: float) -> void:
	velocity = ai_controller.desired_velocity
	move_and_slide()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Turret and attack_cooldown.is_stopped():
		attack_cooldown.start()
		body.damage(damage)
		$HitBox/CollisionShape2D.set_deferred("disabled", true)


func _on_attack_cooldown_timeout() -> void:
	$HitBox/CollisionShape2D.disabled = false
	for b in $HitBox.get_overlapping_bodies():
		_on_hit_box_body_entered(b)


func take_damage(amount: int) -> void:
	$HPBar.current_hp -= 1
	
	if $HPBar.current_hp <= 0:
		queue_free()
