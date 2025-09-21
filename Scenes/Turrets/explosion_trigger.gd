class_name ExplosionTrigger
extends Node

signal explosion_started()

@export var turret: Turret
@export var damage_area: DamageArea
@export var explode_turret: bool = true
@onready var startup_timer: Timer = $StartupTimer

var exploded: bool = false

func _ready() -> void:
	assert(turret and damage_area, "This trigger requires a turret and damage area to function")
	
	startup_timer.start()
	turret.get_node("VisionRange/CollisionShape2D").disabled = true
	
	turret.target_changed.connect(func(t): if t: 
		explode(t)
		)
	
func explode(_target: Enemy = null) -> void:
	if exploded:
		return
		
	if explode_turret:
		exploded = true
	
	explosion_started.emit()


func _on_startup_timer_timeout() -> void:
	turret.get_node("VisionRange/CollisionShape2D").disabled = false
