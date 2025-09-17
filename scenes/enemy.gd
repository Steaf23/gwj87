class_name Enemy
extends CharacterBody2D

@export var damage: int = 1

@onready var ai_controller: AIController = $AIController
@onready var attack_cooldown: Timer = %AttackCooldown

var attacking: bool = false

func _physics_process(_delta: float) -> void:
	if not attacking:
		velocity = ai_controller.desired_velocity
		move_and_slide()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Turret and attack_cooldown.is_stopped():
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


func take_damage(_amount: int) -> void:
	$HPBar.current_hp -= 1
	
	if $HPBar.current_hp <= 0:
		queue_free()
