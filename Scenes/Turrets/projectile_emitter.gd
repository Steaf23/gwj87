class_name ProjectileEmitter
extends Node2D

@export var turret: Turret

## Empty direction means the direction will be chosen randomly
@export var direction: Vector2
@export var projectile: PackedScene

@export var direction_target: Enemy

@onready var shooting: bool = false:
	set(value):
		if not shooting and value:
			if $Cooldown.is_stopped():
				shoot.call_deferred()
		shooting = value

func _ready() -> void:
	assert(turret, "Assign a turret to this emitter!")
	
	turret.died.connect(
		func():
			shooting = false)
	turret.target_changed.connect(
		func(new_target: Enemy):
			shooting = new_target != null
			direction_target = new_target
			)
			
	if shooting:
		shoot.call_deferred()


## Should be called deferred
func shoot() -> void:
	var p: Projectile = projectile.instantiate()
	add_child(p)
	p.speed = TurretData.turrets[turret.type].projectile_speed
	p.global_position = global_position
	p.look_at(global_position + direction)
	$Cooldown.start()


func _on_cooldown_timeout() -> void:
	if shooting:
		shoot.call_deferred()


func get_projectile_speed() -> float:
	return TurretData.turrets[turret.type].projectile_speed


func _physics_process(_delta: float) -> void:
	if direction_target:
		var target = get_lead_position(global_position, direction_target.global_position, direction_target.get_real_velocity(), get_projectile_speed())
		direction = global_position.direction_to(target)
		
		
func get_lead_position(shooter_pos: Vector2, target_pos: Vector2, target_vel: Vector2, bullet_speed: float) -> Vector2:
	var to_target = target_pos - shooter_pos

	var a = target_vel.length_squared() - bullet_speed * bullet_speed
	var b = 2 * to_target.dot(target_vel)
	var c = to_target.length_squared()

	var d = b * b - 4 * a * c
	if d < 0 or abs(a) < 0.001:
		return target_pos # no smart solution exists

	var sqrt_disc = sqrt(d)

	var t1 = (-b + sqrt_disc) / (2 * a)
	var t2 = (-b - sqrt_disc) / (2 * a)
	var t = min(t1, t2)
	if t < 0:
		t = max(t1, t2)
	if t < 0:
		return target_pos

	return target_pos + target_vel * t
