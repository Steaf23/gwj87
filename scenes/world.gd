extends Node2D


func _ready() -> void:
	$Enemies/Enemy.ai_controller.navigation_target = $Turrets/Elder

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place"):
		var turret = preload("res://scenes/turret.tscn").instantiate()
		%Turrets.add_child(turret)
		turret.global_position = $Ground.local_to_map($Ground.get_local_mouse_position()) * 32
		
func add_enemy() -> void:
	pass
