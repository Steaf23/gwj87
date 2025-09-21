extends Node2D

@export var reward: int = 800
@export var turret: Turret


func _ready() -> void:
	assert(turret, "No turret set in inspector!")
	
	turret.died.connect(_on_turret_died)


func _on_turret_died() -> void:
	turret.world.player_points += reward
