extends Node2D


var turrets: Dictionary[Vector2i, Node]

@onready var elder: Turret = %Objects/Elder


func _ready() -> void:
	%Objects/Enemy.ai_controller.navigation_target = %Objects/Elder
	for child in %Objects.get_children():
		if child is Turret:
			turrets[$Ground.local_to_map($Ground.to_local(child.global_position))] = child


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place"):
		var cell = $Ground.local_to_map($Ground.get_local_mouse_position())
		if cell in turrets:
			if turrets[cell] == elder:
				return
			# TODO: kill turret properly
			turrets[cell].queue_free()
			turrets.erase(cell)
		
		var turret = preload("res://Scenes/Turrets/acorn_tree.tscn").instantiate()
		turret.died.connect(_on_turret_died.bind(turret))
		%Objects.add_child(turret)
		turrets[cell] = turret
		$Grass.set_cell(cell, 2, Vector2i.ZERO)
		
		turret.global_position = cell * 32
		
		
func _on_turret_died(turret: Turret) -> void:
	assert(turret in turrets.values())
	
	for cell in turrets.keys():
		var t = turrets[cell]
		if t == turret:
			turrets[cell].queue_free()
			turrets.erase(cell)
			break
		
		
func add_enemy() -> void:
	pass
