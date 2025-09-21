extends Node2D

@export var color: Color = Color(0.0, 0.847, 0.239, 1.0):
	set(value):
		color = value
		queue_redraw()

@onready var radius: int = 100:
	set(value):
		radius = value
		queue_redraw()


func _draw() -> void:
	var trans_color = color
	trans_color.a = 0.3
	if radius > 4.0:
		draw_circle(Vector2i.ZERO, radius, trans_color)
		draw_circle(Vector2i.ZERO, radius, color, false, 2)
	draw_rect(Rect2(-16, -16, 32, 32), trans_color)
