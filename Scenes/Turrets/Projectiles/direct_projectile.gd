extends Projectile


func enemy_hit(_body: Enemy):
	pass


func _on_area_entered(area: Area2D) -> void:
	if area is not HurtBox:
		return
		
	area.damage(damage, effect)
	destroy()
