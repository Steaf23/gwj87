extends Node


var turrets: Dictionary[Turret.TURRET_TYPE, Dictionary] = {
	Turret.TURRET_TYPE.ACORN: {
		"scene": preload("uid://d2w0j8x1cvwo7"),
		"name": "Acorn Tree",
		"projectile_speed": 100,
		"vision_range": 75,
		"price": 300
	},
	Turret.TURRET_TYPE.CHESTNUT: {
		"scene": preload("uid://b8fxcls1dlt0i"),
		"name": "Chestnut Tree",
		"projectile_speed": 50,
		"vision_range": 100,
		"price": 500
	},
	Turret.TURRET_TYPE.CONE: {
		"scene": preload("uid://c8jqqylagwria"),
		"name": "Pine Tree",
		"projectile_speed": 45,
		"vision_range": 65,
		"price": 1
	},
	Turret.TURRET_TYPE.MUSHROOM_MINE: {
		"scene": preload("uid://1xsa55uxi1te"),
		"name": "Mushroom Mine",
		"projectile_speed": 0,
		"vision_range": 20,
		"price": 1,
	},
		Turret.TURRET_TYPE.GROW_MUSHROOM: {
		"scene": preload("uid://b6fxibbuh2g66"),
		"name": "Grow Mushroom",
		"projectile_speed": 0,
		"vision_range": 16,
		"price": 1,
	}
}
