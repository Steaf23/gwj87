class_name BirchTree
extends Turret


func _ready() -> void:
	world.enemy_spawner.enemy_died.connect(_on_enemy_died)


func spread() -> void:
	var cells = get_available_cells()
	if cells.is_empty():
		return
		
	var cell = get_available_cells().pick_random()
	if cell in world.turrets:
		var turret: Turret = world.turrets[cell]
		if turret is LeafPile and turret.stage < turret.max_stage:
			turret.stage += 1
			if turret.stage == turret.max_stage:
				world.set_grass(cell, true)
	else:
		var pile = world.add_turret(Turret.TURRET_TYPE.LEAVES, cell, false)
		pile.stage = 0
	
		
		
func get_available_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var this_cell = world.cell_of_turret(self)
	for y in 3:
		for x in 3:
			var cell = this_cell - Vector2i.ONE + Vector2i(x, y)
			if cell in world.turrets:
				var turret: Turret = world.turrets[cell]
				if turret is LeafPile and turret.stage < turret.max_stage:
					result.append(cell)
			else:
				result.append(cell)
	return result


func _on_enemy_died(_enemy: Enemy) -> void:
	spread()
