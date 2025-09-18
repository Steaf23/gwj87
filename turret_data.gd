extends Node


var turrets: Dictionary[Turret.TURRET_TYPE, Dictionary] = {
	Turret.TURRET_TYPE.ACORN: {
		"name": "Acorn Tree",
		"projectile_speed": 100,
		"vision_range": 75,
		"price": 300
	},
	Turret.TURRET_TYPE.CHESTNUT: {
		"name": "Chestnut Tree",
		"projectile_speed": 50,
		"vision_range": 100,
		"price": 500
	},
	Turret.TURRET_TYPE.CONE: {
		"name": "Pine Tree",
		"projectile_speed": 45,
		"vision_range": 65,
		"price": 1000
	}
}
