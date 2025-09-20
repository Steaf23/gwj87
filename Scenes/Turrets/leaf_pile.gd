class_name LeafPile
extends Turret

@export var max_stage = 3

@onready var stage: int = 0:
	set(value):
		stage = value
		
		if not is_node_ready():
			await ready
		$AnimatedSprite2D.play(str(stage))
