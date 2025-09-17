extends Node2D

var available_turrets: Dictionary = {
	Turret.TURRET_TYPE.ACORN: preload("res://Scenes/Turrets/acorn_tree.tscn"),
	Turret.TURRET_TYPE.CHESTNUT: preload("res://Scenes/Turrets/chestnut_tree.tscn"),
	Turret.TURRET_TYPE.CONE: preload("res://Scenes/Turrets/acorn_tree.tscn"),
}


var turrets: Dictionary[Vector2i, Node]

@onready var elder: Turret = %Objects/Elder
@onready var turret_container: TurretContainer = $CanvasLayer/TurretContainer
@onready var ground: TileMapLayer = $Ground

@onready var placing_turret: Turret.TURRET_TYPE = Turret.TURRET_TYPE.NONE


func _ready() -> void:
	for child in %Objects.get_children():
		if child is Turret:
			turrets[$Ground.local_to_map($Ground.to_local(child.global_position))] = child


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		if not %PlacePreview.is_visible() or placing_turret == Turret.TURRET_TYPE.NONE:
			return
		
		%PlacePreview.hide()
		
		var cell = $Ground.local_to_map($Ground.get_local_mouse_position())
		if cell in turrets:
			if turrets[cell] == elder:
				return
			# TODO: kill turret properly
			turrets[cell].queue_free()
			turrets.erase(cell)
		
		var turret = available_turrets[placing_turret].instantiate()
		turret.died.connect(_on_turret_died.bind(turret))
		%Objects.add_child(turret)
		turrets[cell] = turret
		$Grass.set_cell(cell, 2, Vector2i.ZERO)
		
		turret.global_position = cell * 32
		
		placing_turret = Turret.TURRET_TYPE.NONE
		
		
func _on_turret_died(turret: Turret) -> void:
	assert(turret in turrets.values())
	
	for cell in turrets.keys():
		var t = turrets[cell]
		if t == turret:
			turrets[cell].queue_free()
			turrets.erase(cell)
			break
	

func _process(delta: float) -> void:
	update_preview()


func _on_turret_container_dragging_turret(type: Turret.TURRET_TYPE) -> void:
	placing_turret = type
	%PlacePreview.radius = TurretData.turrets[type].vision_range
	%PlacePreview.show()
	

func update_preview() -> void:
	
	if not %PlacePreview.is_visible():
		return
	
	%PlacePreview.global_position = ground.map_to_local(ground.local_to_map(get_global_mouse_position())) 
