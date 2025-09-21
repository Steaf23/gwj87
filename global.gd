extends Node

const MENU = preload("uid://co637quvudisn")

const LEVEL_1 = preload("uid://bqgawphyt05re")
const LEVEL_2 = preload("uid://cotqtw070igay")

const levels: Dictionary[int, PackedScene] = {
	1: LEVEL_1, 
	2: LEVEL_2,
	}

# Levels: Waves
var levels_won: Dictionary[int, int] = {}


func win_level(level: int, wave: int) -> void:
	if level in levels_won and levels_won[level] < wave:
		return
	
	levels_won[level] = wave


func get_completed_wave(level: int) -> int:
	return levels_won[level] if level in levels_won else -1


func load_level(level: int) -> void:
	if level in levels:
		var level_scn = levels[level]
		get_tree().change_scene_to_packed(level_scn)


func load_menu() -> void:
	get_tree().change_scene_to_packed(MENU)
