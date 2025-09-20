class_name ImpactProjectile
extends Projectile

@onready var damage_area: DamageArea = %DamageArea

func _on_area_entered(area: Area2D) -> void:
	if area is not HurtBox:
		return
		
	damage_area.trigger()
	destroy()
