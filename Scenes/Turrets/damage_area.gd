class_name DamageArea
extends Area2D

@export var damage: int = 1
@export var effect: Enemy.DAMAGE_EFFECT = Enemy.DAMAGE_EFFECT.NONE


func trigger() -> void:
	for b in get_overlapping_bodies():
		if b is Enemy:
			b.take_damage(damage, effect)
