class_name TurretButton
extends TextureButton

signal drag_started(type: Turret.TURRET_TYPE)

@onready var icon: Texture2D:
	set(value):
		icon = value
		texture_normal = texture_normal.duplicate()
		texture_normal.atlas = icon

var type: Turret.TURRET_TYPE = Turret.TURRET_TYPE.ACORN


func _get_drag_data(_at_position: Vector2) -> Variant:
	var prev = Control.new()
	var texture = TextureRect.new()
	prev.add_child(texture)
	texture.texture = texture_normal
	texture.position += Vector2(-24, -24)
	texture.modulate = Color(1.0, 1.0, 1.0, 0.7)
	set_drag_preview(prev)
	drag_started.emit(type)
	return type
