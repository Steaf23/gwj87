class_name World
extends Node2D

@export var win_threshold: float = 40.0
@export var level: int = 0

var turrets: Dictionary[Vector2i, Node]

@onready var elder: Turret = %Objects/Elder
@onready var turret_container: TurretContainer = $CanvasLayer/TurretContainer
@onready var ground: TileMapLayer = $Ground
@onready var points_label: Label = %PointsLabel
@onready var wave_button: Button = %WaveButton
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var place_preview: Node2D = %PlacePreview
@onready var range_checker: Node2D = %RangeChecker
@onready var grass: TileMapLayer = $Grass
@onready var grass_percent: TextureProgressBar = %GrassPercent
@onready var win_popup: CanvasLayer = $WinPopup
@onready var boulders: TileMapLayer = $Boulders

@onready var placing_turret: Turret.TURRET_TYPE = Turret.TURRET_TYPE.NONE
@onready var unlocked_final_wave: bool = false
@onready var final_wave: bool = false


var wave: int = 0
var next_wave_budget: int = 2
		
var player_points: int = 0:
	set(value):
		player_points = value
		points_label.text = str(player_points)
		
		update_turret_buttons()

var selected_turret: Turret = null

func _ready() -> void:
	for c in boulders.get_used_cells():
		ground.set_cell(c, 0, Vector2i.ZERO)
		boulders.set_cell(c, 3 + randi() % 3, Vector2i.ZERO)
	
	win_popup.hide()
	grass_percent.max_value = win_threshold
	player_points = 750
	
	for child in %Objects.get_children():
		if child is Turret:
			child.died.connect(_on_turret_died.bind(child))
			child.world = self
			turrets[$Ground.local_to_map($Ground.to_local(child.global_position))] = child
	
	SoundManager.play_music(Sounds.MUSIC_GAME)
	SoundManager.play_ambient(Sounds.AMBIENT)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		if not place_preview.is_visible() or placing_turret == Turret.TURRET_TYPE.NONE:
			return
		if Rect2(%DropContainer.global_position, %DropContainer.size).has_point(get_global_mouse_position()):
			placing_turret = Turret.TURRET_TYPE.NONE
			place_preview.hide()
			%DropContainer.hide()
			return

		place_preview.hide()
		%DropContainer.hide()
		
		var cell = $Ground.local_to_map($Ground.get_local_mouse_position())
		var turret = add_turret(placing_turret, cell, true)
		if turret == null:
			return
		
		SoundManager.play_random_sfx(Sounds.TURRET_PLACE)
		# remove points for placing turret
		for b: TurretButton in %Buttons.get_children():
			if b.type == placing_turret:
				player_points -= b.active_price
				break
		
		placing_turret = Turret.TURRET_TYPE.NONE
		
		
func _on_turret_died(turret: Turret) -> void:
	if not turret in turrets.values():
		return
	
	if turret.type == Turret.TURRET_TYPE.ELDER:
		# TODO: GAMEOVER
		get_tree().reload_current_scene.call_deferred()
		
	
	for cell in turrets.keys():
		var t = turrets[cell]
		if t == turret:
			turrets.erase(cell)
			break
	

func _process(_delta: float) -> void:
	update_preview()


func _on_turret_container_dragging_turret(type: Turret.TURRET_TYPE) -> void:
	placing_turret = type
	place_preview.radius = TurretData.turrets[type].vision_range
	place_preview.show()
	

func update_preview() -> void:
	if not place_preview.is_visible():
		return
	
	var cell = ground.local_to_map(get_global_mouse_position())
	place_preview.global_position = ground.map_to_local(cell)
	
	if is_invalid_turret_cell(cell):
		place_preview.color = Color("d8335cff")
	else:
		if is_cell_stump(cell):
			place_preview.color = Color("ffd343ff")
		else:
			place_preview.color = Color("#00d83d")
	

func calculate_points() -> int:
	var placed_turrets = %Objects.get_children().filter(func(t): return t is Turret and t.type != Turret.TURRET_TYPE.DEAD and t.type != Turret.TURRET_TYPE.LEAVES).size() - 1
	return (placed_turrets * 2 + grass.get_used_cells().size()) * 50


func calculate_wave_budget() -> int:
	@warning_ignore("integer_division")
	return calculate_points() / 50


func _on_enemy_spawner_wave_cleared() -> void:
	if final_wave and unlocked_final_wave and not is_complete():
		win_popup.show()
		Global.win_level(level, wave)
		
	player_points += calculate_points()
	next_wave_budget = calculate_wave_budget()
	wave_button.disabled = false
	

func update_turret_buttons() -> void:
	for b: TurretButton in %Buttons.get_children():
		b.disabled = player_points < b.active_price
			

func _on_wave_button_pressed() -> void:
	enemy_spawner.start_wave(next_wave_budget)
	wave_button.disabled = true
	wave += 1
	%Wave.text = "Wave " + str(wave)
	SoundManager.play_sfx(Sounds.BUTTON_PRESS)
	
	if unlocked_final_wave and not final_wave:
		final_wave = true
		

func cell_of_turret(turret: Turret) -> Vector2i:
	assert(turret in turrets.values(), "Cannot get cell of a turret I don't own.")
	
	for c in turrets.keys():
		if turrets[c] == turret:
			return c
	
	return Vector2i.ZERO


func add_turret(type: Turret.TURRET_TYPE, cell: Vector2i, add_grass: bool) -> Turret:
	if is_invalid_turret_cell(cell):
		return null
		
	if cell in turrets:
		turrets[cell].kill()

	var turret: Turret = TurretData.turrets[type].scene.instantiate()
	turret.died.connect(_on_turret_died.bind(turret))
	turret.turret_clicked.connect(_on_turret_clicked.bind(turret))
	turret.world = self
	%Objects.add_child.call_deferred(turret)
	turrets[cell] = turret
	
	if add_grass:
		set_grass(cell, true)
	
	turret.global_position = cell * 32
	return turret


func set_grass(cell: Vector2i, value: bool) -> void:
	if value:
		grass.set_cell(cell, 2, Vector2i.ZERO)
		update_progress()
	else:
		grass.erase_cell(cell)


func update_progress() -> void:
	# TODO: subtract boulder tiles
	var total_cells = 11 * 20
	
	grass_percent.value = grass.get_used_cells().size() / float(total_cells) * 100
	if grass_percent.value >= win_threshold:
		enter_last_wave()


func enter_last_wave() -> void:
	if is_complete():
		return
	
	%CompleteLabel.show()
	unlocked_final_wave = true
	wave_button.text = "Final Wave"


func _on_foldable_container_folding_changed(_is_folded: bool) -> void:
	SoundManager.play_sfx(Sounds.BUTTON_PRESS)


func _on_map_select_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_continue_pressed() -> void:
	wave_button.text = "Next Wave"
	win_popup.hide()
	grass_percent.hide()
	unlocked_final_wave = false


func is_complete() -> bool:
	return Global.get_completed_wave(level) != -1


func is_invalid_turret_cell(cell: Vector2i) -> bool:
	var oob = cell.x < 0 or cell.y < 0 or cell.x > 19 or cell.y > 10
	var boulder = cell in boulders.get_used_cells()
	var elder_cell = cell_of_turret(elder) == cell
	return oob or boulder or elder_cell


func is_cell_stump(cell: Vector2i) -> bool:
	return cell in turrets and turrets[cell].type == Turret.TURRET_TYPE.DEAD

func _on_turret_clicked(turret: Turret) -> void:
	if selected_turret == turret:
		range_checker.hide()
		selected_turret = null
	else:
		range_checker.radius = TurretData.turrets[turret.type].vision_range
		range_checker.global_position = turret.global_position + Vector2(grass.tile_set.tile_size) / 2
		range_checker.show()
		selected_turret = turret


func _on_bar_panel_mouse_entered() -> void:
	grass_percent.modulate = Color(1.0, 1.0, 1.0, 0.2)


func _on_bar_panel_mouse_exited() -> void:
	grass_percent.modulate = Color(1.0, 1.0, 1.0, 1.0)
