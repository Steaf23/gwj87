class_name ImpactProjectile
extends Projectile

@onready var damage_area: DamageArea = %DamageArea


func enemy_hit(_body: Enemy):
	damage_area.trigger()
	queue_free()
