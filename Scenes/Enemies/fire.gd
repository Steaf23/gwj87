extends GPUParticles2D


func _on_flame_enemy_attack_started(_attack_duration: float) -> void:
	restart()
