class_name GrowStageAnimator
extends AnimatedSprite2D


func set_stage(stage: int) -> void:
	var stage_anim = str(clamp(stage, 0, 5))
	play(stage_anim)
