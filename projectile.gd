class_name Projectile
extends Area2D

@export var speed: int = 100
@export var lifespan: float = 0.75


func _ready() -> void:
	await get_tree().create_timer(lifespan).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(global_rotation) * speed * delta
