extends Node2D


@export var max_hp: int = 20:
	set(value):
		max_hp = value
		if not is_node_ready():
			await ready
		$ProgressBar.max_value = max_hp

@onready var current_hp: int = max_hp:
	set(value):
		current_hp = value
		$ProgressBar.value = current_hp


func _ready() -> void:
	max_hp = max_hp
	current_hp = max_hp
