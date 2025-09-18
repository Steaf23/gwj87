class_name ExplosionTrigger
extends Node

@export var turret: Turret
@export var damage_area: DamageArea
@onready var startup_timer: Timer = $StartupTimer

func _ready() -> void:
	assert(turret and damage_area, "This trigger requires a turret and damage area to function")
	
	startup_timer.start()
	turret.get_node("VisionRange/CollisionShape2D").disabled = true
	
	turret.target_changed.connect(func(t): if t: 
		explode()
		)
	
func explode() -> void:
	damage_area.trigger()
	turret.damage(turret.hp)


func _on_startup_timer_timeout() -> void:
	turret.get_node("VisionRange/CollisionShape2D").disabled = false
