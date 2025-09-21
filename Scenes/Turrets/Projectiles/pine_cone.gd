extends ImpactProjectile

func _lifespan_reached():
	if dead:
		return
	damage_area.trigger()


func _process(delta: float) -> void:
	$Sprite2D.global_rotation += delta * 10


func _on_damage_area_triggered() -> void:
	$ExplodeParticles.global_position = global_position
	SoundManager.play_sfx(Sounds.PINECONE_EXPLODE, 0.3)
	$ExplodeParticles.restart()
	
	await get_tree().create_timer($ExplodeParticles.lifetime).timeout
	destroy()
