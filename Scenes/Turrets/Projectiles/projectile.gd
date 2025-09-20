class_name Projectile
extends Area2D

@export var lifespan: float = 0.75
@export var damage: int = 1
@export var effect: Enemy.DAMAGE_EFFECT

@onready var speed: int = 100

var dead = false


func _lifespan_reached():
	destroy()
	

func _ready() -> void:
	await get_tree().create_timer(lifespan).timeout
	
	if not is_instance_valid(self): return
	_lifespan_reached()


func _physics_process(delta: float) -> void:
	if dead:
		return
	position += Vector2.RIGHT.rotated(global_rotation) * speed * delta


func destroy() -> void:
	if dead: return
	
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("fade")
