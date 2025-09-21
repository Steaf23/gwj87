class_name LevelButton
extends MarginContainer

@onready var level: int = 0:
	set(value):
		level = value
		%Button/Label.text = str(level)
		
@onready var completed_wave: int = -1:
	set(value):
		completed_wave = value
		var completed = completed_wave != -1
		
		%Completed.visible = completed
		%Completed.text = "Completed in\n %s waves!" % [completed_wave]


func _ready() -> void:
	%Button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	Global.load_level(level)
	SoundManager.play_sfx(Sounds.BUTTON_PRESS)
