extends MarginContainer

const LEVEL_BUTTON = preload("uid://do87i5f61fatu")

func _ready() -> void:
	get_tree().paused = false
	SoundManager.play_ambient(Sounds.AMBIENT)
	
	for l in Global.levels.keys():
		add_level(l)
	

func add_level(level: int) -> void:
	var btn: LevelButton = LEVEL_BUTTON.instantiate()
	%Buttons.add_child(btn)
	btn.level = level
	btn.completed_wave = Global.get_completed_wave(level)
