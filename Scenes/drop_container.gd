extends MarginContainer

signal cancel_placement()

func _drop_data(_at_position: Vector2, _data: Variant) -> void:
	cancel_placement.emit()


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Turret.TURRET_TYPE:
		return true
	
	return false
