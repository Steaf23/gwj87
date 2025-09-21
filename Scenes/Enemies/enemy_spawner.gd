class_name EnemySpawner
extends Node2D

const enemies: Dictionary[int, PackedScene] = {
	1: preload("res://Scenes/Enemies/axe_enemy.tscn"),
	5: preload("res://Scenes/Enemies/saw_enemy.tscn"),
	10: preload("res://Scenes/Enemies/flame_enemy.tscn"),
}

signal wave_cleared()
signal enemy_died(enemy: Enemy)

var amount_to_spawn: int = 5
var spawn_counter: int = 0
var wave_active: bool = false


func start_wave(_spawn_count: int) -> void:
	wave_active = true
	amount_to_spawn = _spawn_count
	spawn_counter = 0
	$SpawnTimer.start()
	spawn()
	

func spawn() -> void:
	var enemy: Enemy = enemies.values().pick_random().instantiate()
	%Objects.add_child(enemy)
	if not enemy.is_node_ready():
		await enemy.ready
	enemy.global_position = get_random_spawn()
	enemy.ai_controller.navigation_target = %Objects/Elder
	enemy.died.connect(_on_enemy_died.bind(enemy))
	spawn_counter += 1


func _on_spawn_timer_timeout() -> void:
	if spawn_counter >= amount_to_spawn:
		$SpawnTimer.stop()
		return
	
	spawn()


func _on_enemy_died(enemy: Enemy) -> void:
	enemy_died.emit(enemy)
	if spawn_counter >= amount_to_spawn:
		if %Objects.get_children().filter(func(c): return c is Enemy and not c.is_dead).is_empty():
			wave_active = false
			wave_cleared.emit()
	

func get_random_spawn() -> Vector2i:
	if %Markers.get_child_count() == 0:
		return global_position
	else:
		return %Markers.get_children().pick_random().global_position
