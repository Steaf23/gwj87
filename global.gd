extends Node

const MENU = preload("uid://co637quvudisn")

const WORLD = preload("uid://cb5ogx63v83yx")

# Levels: Waves
var levels_won: Dictionary[int, int] = {}


func win_level(level: int, wave: int) -> void:
	if not level in levels_won or levels_won[level] < wave:
		return
	
	levels_won[level] = wave


func get_completed_wave(level: int) -> int:
	return levels_won[level] if level in levels_won else -1


func load_level(level: int) -> void:
	match level:
		1: get_tree().change_scene_to_packed(WORLD)


func load_menu() -> void:
	get_tree().change_scene_to_packed(MENU)
