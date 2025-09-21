class_name MushroomMine
extends Turret


func _ready() -> void:
	$ExplosionSprite.hide()


func _on_explosion_trigger_explosion_started() -> void:
	$ExplosionSprite.show()
	$ExplosionSprite.play("explode")
	$Sprite2D.hide()
	
	SoundManager.play_random_sfx(Sounds.MUSHROOM_EXPLODE, 0.7)
	
	await get_tree().create_timer(0.4).timeout
	$DamageArea.trigger()


func _on_explosion_sprite_animation_finished() -> void:
	kill()
		
