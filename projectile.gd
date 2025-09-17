class_name Projectile
extends Area2D

@export var lifespan: float = 0.75
@export var damage: int = 1
@export var effect: Enemy.DAMAGE_EFFECT

@onready var speed: int = 100

func _ready() -> void:
	await get_tree().create_timer(lifespan).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(global_rotation) * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage, effect)
		queue_free()
