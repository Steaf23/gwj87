extends Node


var turrets: Dictionary[Turret.TURRET_TYPE, Dictionary] = {
	Turret.TURRET_TYPE.ACORN: {
		"name": "Acorn Tree",
		"projectile_speed": 100,
		"vision_range": 75,
	},
	Turret.TURRET_TYPE.CHESTNUT: {
		"name": "Chestnut Tree",
		"projectile_speed": 40,
		"vision_range": 100,
	}
}
