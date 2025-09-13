class_name Turret
extends StaticBody2D

@onready var hp: int = 3

func damage(amount: int) -> void:
	hp -= 1
	if hp <= 0:
		queue_free()
