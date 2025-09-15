class_name Turret
extends StaticBody2D

signal died()

@onready var hp: int = 3

@onready var projectile_emitter: ProjectileEmitter = $ProjectileEmitter

var visible_targets: Array[Enemy] = []
var current_target: Enemy = null

var dead = false

func damage(amount: int) -> void:
	if dead:
		return
	hp -= 1
	if hp <= 0:
		died.emit()
		projectile_emitter.shooting = false


func _on_vision_range_body_entered(body: Node2D) -> void:
	if not body in visible_targets and body is Enemy:
		visible_targets.append(body)
		update_target()


func _on_vision_range_body_exited(body: Node2D) -> void:
	if body in visible_targets:
		visible_targets.erase(body)
		update_target()
	

func update_target() -> void:
	var has_target = not visible_targets.is_empty()
	if has_target:
		current_target = visible_targets.front()
	else:
		current_target = null
	
	projectile_emitter.shooting = has_target


func _physics_process(delta: float) -> void:
	if current_target:
		current_target.velocity
		var target = get_lead_position(global_position, current_target.global_position, current_target.velocity, projectile_emitter.get_projectile_speed())
		projectile_emitter.direction = projectile_emitter.global_position.direction_to(target)


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
