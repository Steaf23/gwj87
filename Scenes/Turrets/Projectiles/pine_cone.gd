extends ImpactProjectile

func _lifespan_reached():
	damage_area.trigger()
	super._lifespan_reached()


func _process(delta: float) -> void:
	$Sprite2D.global_rotation += delta * 10
