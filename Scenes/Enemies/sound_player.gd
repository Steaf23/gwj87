extends Node

enum TYPE {
	AXE,
	SAW,
	FLAME,
}

@export var type: TYPE


func play_saw() -> void:
	SoundManager.play_random_sfx(Sounds.ATTACK_CHAINSAW, 0.2)


func play_axe() -> void:
	SoundManager.play_random_sfx(Sounds.ATTACK_AXE, 0.6)


func play_flamethrower() -> void:
	SoundManager.play_random_sfx(Sounds.ATTACK_FLAMETHROWER, 0.4)


func _on_enemy_attack_started(_attack_duration: float) -> void:
	match type:
		TYPE.SAW: play_saw()
		TYPE.AXE: play_axe()
		TYPE.FLAME: play_flamethrower()
