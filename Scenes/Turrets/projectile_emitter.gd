class_name ProjectileEmitter
extends Node2D

@export var turret: Turret

## Empty direction means the direction will be chosen randomly
@export var direction: Vector2
@export var projectile: PackedScene

@onready var shooting: bool = false:
	set(value):
		if not shooting and value:
			if $Cooldown.is_stopped():
				shoot.call_deferred()
		shooting = value

func _ready() -> void:
	assert(turret, "Assign a turret to this emitter!")
	
	if shooting:
		shoot.call_deferred()


## Should be called deferred
func shoot() -> void:
	var p = projectile.instantiate()
	add_child(p)
	p.global_position = global_position
	p.look_at(global_position + direction)
	$Cooldown.start()


func _on_cooldown_timeout() -> void:
	if shooting:
		shoot.call_deferred()


func get_projectile_speed() -> float:
	return 75
