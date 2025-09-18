extends Node2D

@onready var radius: int = 100:
	set(value):
		radius = value
		queue_redraw()


func _draw() -> void:
	draw_circle(Vector2i.ZERO, radius, Color(0.0, 0.847, 0.239, 0.3))
	draw_circle(Vector2i.ZERO, radius, Color(0.0, 0.847, 0.239, 1.0), false, 2)
	draw_rect(Rect2(-16, -16, 32, 32), Color(0.0, 0.847, 0.239, 1.0))
