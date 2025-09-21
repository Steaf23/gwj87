class_name EnemySpawner
extends Node2D

const enemies: Array = [
	{"scene": preload("res://Scenes/Enemies/axe_enemy.tscn"), "weight": 1},
	{"scene": preload("res://Scenes/Enemies/saw_enemy.tscn"), "weight": 5},
	{"scene": preload("res://Scenes/Enemies/flame_enemy.tscn"), "weight": 10},
	{"scene": preload("res://Scenes/Enemies/bulldozer_enemy.tscn"), "weight": 30},
]

signal wave_cleared()
signal enemy_died(enemy: Enemy)

@export var min_group_size = 3

var amount_to_spawn: int = 5
var spawn_counter: int = 0
var wave_active: bool = false

# array of enemies to spawn on which positions, in reverse spawning order (to take from the back)
var wave_spawns: Array[Dictionary]

func _ready() -> void:
	randomize()


func prepare_wave(budget: int) -> Array[Node2D]:
	return build_wave_spawns(budget)


func start_wave() -> void:
	wave_active = true
	spawn_counter = 0
	$SpawnTimer.start()
	spawn()
	

func spawn() -> void:
	var next_spawn = wave_spawns.pop_back()
	var enemy: Enemy = next_spawn.enemy.instantiate()
	%Objects.add_child(enemy)
	if not enemy.is_node_ready():
		await enemy.ready
	enemy.global_position = next_spawn.pos.global_position
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
	

func get_random_spawn() -> Node2D:
	if %Markers.get_child_count() == 0:
		return null
	else:
		return %Markers.get_children().pick_random()


# returns list of used spawn points
func build_wave_spawns(budget: int) -> Array[Node2D]:
	print("Building wave with budget: ", budget)
	var full_budget = budget
	var enemy_list: Array[PackedScene] = []
	while full_budget > 0:
		var enemy = get_spawnable_with_budget(full_budget)
		full_budget -= enemy.weight
		enemy_list.append(enemy.scene)
	
	var max_groups = 1
	if enemy_list.size() > min_group_size:
		@warning_ignore("integer_division")
		max_groups = enemy_list.size() / min_group_size
	var using_groups = (randi() % max_groups) + 1
	
	@warning_ignore("integer_division")
	var enemies_per_group = enemy_list.size() / using_groups
	
	# Separate enemies into groups
	var groups: Dictionary[int, Array] = {}
	
	for group_idx in using_groups:
		for i in enemies_per_group:
			if not group_idx in groups:
				groups[group_idx] = []
			groups[group_idx].append(enemy_list.pop_back())
	
	while not enemy_list.is_empty():
		var idx = groups.keys().pick_random()
		groups[idx].append(enemy_list.pop_back())
	

	wave_spawns.clear()
	
	var spawn_list: Array[Node2D] = []
	for idx in groups.keys():
		var group_spawn = get_random_spawn()
		if group_spawn not in spawn_list:
			spawn_list.append(group_spawn)
		for pkd_scn in groups[idx]:
			wave_spawns.append({"pos": group_spawn, "enemy": pkd_scn})
	
	amount_to_spawn = wave_spawns.size()
	print("Spawning enemies in %s groups and spawning %s enemies in total." % [groups.size(), wave_spawns.size()])
	
	return spawn_list
	
func get_spawnable_with_budget(budget: int) -> Dictionary:
	
	var choices = enemies.filter(func(dict): return budget >= dict.weight)
	if choices.is_empty():
		return {"scene": null, "weight": 0}
	
	return choices.pick_random()


func get_spawnable_with_budget_weighted(budget: int) -> Dictionary:
	var choices = enemies.filter(func(dict): return budget >= dict.weight)
	if choices.is_empty():
		return {"scene": null, "weight": 0}
	
	var weight_sum = 0
	for c in choices:
		weight_sum += c.weight
	
	var pivot = randi() % weight_sum	
	var cumulative = 0
	for c in choices:
		cumulative += choices[c]
		if pivot < cumulative:
			return c
	
	assert(false)
	return choices.pick_random()
