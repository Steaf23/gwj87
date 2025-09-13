extends Node2D


var turrets: Dictionary[Vector2i, Node]

func _ready() -> void:
	%Objects/Enemy.ai_controller.navigation_target = %Objects/Elder

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place"):
		var cell = $Ground.local_to_map($Ground.get_local_mouse_position())
		if cell in turrets:
			# TODO: kill turret properly
			turrets[cell].queue_free()
		
		var turret = preload("res://scenes/acorn_tree.tscn").instantiate()
		%Objects.add_child(turret)
		turrets[cell] = turret
		
		turret.global_position = cell * 32
		
		
func add_enemy() -> void:
	pass
