class_name TurretButton
extends MarginContainer

signal drag_started(type: Turret.TURRET_TYPE)

@onready var texture_rect: TextureRect = %TextureRect
@onready var price: Label = %Price

@onready var icon: Texture2D:
	set(value):
		icon = value
		if not is_node_ready():
			await ready
		texture_rect.texture = icon

var type: Turret.TURRET_TYPE = Turret.TURRET_TYPE.ACORN:
	set(value):
		type = value
		
		if not is_node_ready():
			await ready
		active_price = TurretData.turrets[type].price

var active_price:
	set(value):
		active_price = value
		price.text = str(active_price)
		
var disabled: bool = false:
	set(value):
		disabled = value
		if disabled:
			modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			modulate = Color.WHITE


func _get_drag_data(_at_position: Vector2) -> Variant:
	if disabled:
		return null
		
	var prev = Control.new()
	var texture = TextureRect.new()
	prev.add_child(texture)
	texture.texture = texture_rect.texture
	texture.position += Vector2(-24, -24 - 16)
	texture.modulate = Color(1.0, 1.0, 1.0, 0.7)
	set_drag_preview(prev)
	drag_started.emit(type)
	return type
