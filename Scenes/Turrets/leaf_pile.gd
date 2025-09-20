class_name LeafPile
extends Turret

@export var max_stage = 2

@onready var stage: int = 0:
	set(value):
		stage = value
		
		if not is_node_ready():
			await ready
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, (stage + 1.0) / (max_stage + 1))
