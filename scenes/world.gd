extends Node2D


var turrets: Dictionary[Vector2i, Node]

@onready var elder: Turret = %Objects/Elder
@onready var turret_container: TurretContainer = $CanvasLayer/TurretContainer
@onready var ground: TileMapLayer = $Ground
@onready var points_label: Label = %PointsLabel
@onready var wave_button: Button = %WaveButton
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var place_preview: Node2D = %PlacePreview

@onready var placing_turret: Turret.TURRET_TYPE = Turret.TURRET_TYPE.NONE


var wave: int = 0
var next_wave_budget: int = 2
		
var player_points: int = 0:
	set(value):
		player_points = value
		points_label.text = str(player_points)
		
		update_turret_buttons()

func _ready() -> void:
	player_points = 750
	
	for child in %Objects.get_children():
		if child is Turret:
			if child.type != Turret.TURRET_TYPE.ELDER:
				child.died.connect(_on_turret_died.bind(child))
			turrets[$Ground.local_to_map($Ground.to_local(child.global_position))] = child


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		if not place_preview.is_visible() or placing_turret == Turret.TURRET_TYPE.NONE:
			return
		
		place_preview.hide()
		
		var cell = $Ground.local_to_map($Ground.get_local_mouse_position())
		if cell in turrets:
			if turrets[cell] == elder:
				return
			# TODO: kill turret properly
			turrets[cell].queue_free()
			turrets.erase(cell)
		
		var turret = TurretData.turrets[placing_turret].scene.instantiate()
		turret.died.connect(_on_turret_died.bind(turret))
		%Objects.add_child(turret)
		turrets[cell] = turret
		$Grass.set_cell(cell, 2, Vector2i.ZERO)
		
		turret.global_position = cell * 32
		
		# remove points for placing turret
		for b: TurretButton in %Buttons.get_children():
			if b.type == placing_turret:
				player_points -= b.active_price
				break
				
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
	place_preview.radius = TurretData.turrets[type].vision_range
	place_preview.show()
	

func update_preview() -> void:
	if not place_preview.is_visible():
		return
	
	place_preview.global_position = ground.map_to_local(ground.local_to_map(get_global_mouse_position())) 
	

func calculate_points() -> int:
	var placed_turrets = %Objects.get_children().filter(func(t): return t is Turret and t.type != Turret.TURRET_TYPE.DEAD).size() - 1
	return (placed_turrets * 2 + $Grass.get_used_cells().size()) * 100


func calculate_wave_budget() -> int:
	@warning_ignore("integer_division")
	return calculate_points() / 100


func _on_enemy_spawner_wave_cleared() -> void:
	player_points += calculate_points()
	next_wave_budget = calculate_wave_budget()
	wave_button.disabled = false
	
	# TODO: DEBUG, REMOVE!
	next_wave_budget = 5
	


func update_turret_buttons() -> void:
	for b: TurretButton in %Buttons.get_children():
		b.disabled = player_points < b.active_price
			

func _on_wave_button_pressed() -> void:
	enemy_spawner.start_wave(next_wave_budget)
	wave_button.disabled = true
