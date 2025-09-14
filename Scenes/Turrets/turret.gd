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
		projectile_emitter.direction = projectile_emitter.global_position.direction_to(current_target.global_position)
