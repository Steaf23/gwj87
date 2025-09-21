class_name DamageArea
extends Area2D

signal triggered()

@export var damage: int = 1
@export var effect: Enemy.DAMAGE_EFFECT = Enemy.DAMAGE_EFFECT.NONE


func trigger() -> void:
	triggered.emit()
	for b in get_overlapping_areas():
		if b is HurtBox:
			b.damage(damage, effect)
