@abstract
class_name Projectile
extends Area2D

@export var lifespan: float = 0.75
@export var damage: int = 1
@export var effect: Enemy.DAMAGE_EFFECT

@onready var speed: int = 100

	
@abstract 
func enemy_hit(body: Enemy)


func _lifespan_reached():
	queue_free()
	

func _ready() -> void:
	await get_tree().create_timer(lifespan).timeout
	
	if not is_instance_valid(self): return
	_lifespan_reached()

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(global_rotation) * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemy_hit(body)
