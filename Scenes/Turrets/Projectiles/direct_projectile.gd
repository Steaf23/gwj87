extends Projectile


func enemy_hit(body: Enemy):
	body.take_damage(damage, effect)
	queue_free()
