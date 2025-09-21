extends PanelContainer

@onready var name_lbl: Label = $Box/PanelContainer/Name
@onready var info_lbl: Label = $Box/Info


func set_turret(turret: Turret.TURRET_TYPE) -> void:
	if not turret in TurretData.turrets:
		assert(false, "NO data found for turret %s" % [turret])
	
	name_lbl.text = TurretData.turrets[turret].name
	info_lbl.text = TurretData.turrets[turret].description
