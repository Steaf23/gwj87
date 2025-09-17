class_name EnemySpawner
extends Node2D


@export var amount_to_spawn: int = 10

var spawn_count: int = 0


func _ready() -> void:
	spawn()
	

func spawn() -> void:
	var enemy = preload("res://Scenes/enemy.tscn").instantiate()
	%Objects.add_child(enemy)
	if not enemy.is_node_ready():
		await enemy.ready
	enemy.global_position = global_position
	enemy.ai_controller.navigation_target = %Objects/Elder


func _on_spawn_timer_timeout() -> void:
	if spawn_count >= amount_to_spawn:
		$SpawnTimer.stop()
		return
	
	spawn()
