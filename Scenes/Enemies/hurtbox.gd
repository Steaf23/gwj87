class_name HurtBox
extends Area2D


signal damaged(amount: int, effect: Enemy.DAMAGE_EFFECT)

func damage(amount, effect):
	damaged.emit(amount, effect)
