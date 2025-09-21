extends Node


var turrets: Dictionary[Turret.TURRET_TYPE, Dictionary] = {
	Turret.TURRET_TYPE.ACORN: {
		"scene": preload("uid://d2w0j8x1cvwo7"),
		"name": "Acorn Tree",
		"projectile_speed": 120,
		"vision_range": 85,
		"price": 400,
		"description": "Shoots acorns at trespassers from a medium distance."
	},
	Turret.TURRET_TYPE.CHESTNUT: {
		"scene": preload("uid://b8fxcls1dlt0i"),
		"name": "Chestnut Tree",
		"projectile_speed": 60,
		"vision_range": 110,
		"price": 500,
		"description": "Launches spiky chestnuts from medium-long range that stun trespassers.",
	},
	Turret.TURRET_TYPE.CONE: {
		"scene": preload("uid://c8jqqylagwria"),
		"name": "Pine Tree",
		"projectile_speed": 45,
		"vision_range": 70,
		"price": 900,
		"description": "Chucks pine cones towards trespassers that explode on impact.",
	},
	Turret.TURRET_TYPE.MUSHROOM_MINE: {
		"scene": preload("uid://1xsa55uxi1te"),
		"name": "Fly Agaric",
		"projectile_speed": 0,
		"vision_range": 20,
		"price": 600,
		"description": "Explodes when tresspassers approach it."
	},
	Turret.TURRET_TYPE.ROOTS: {
		"scene": preload("uid://e4jktbx8c7y4"),
		"name": "Roots",
		"projectile_speed": 0,
		"vision_range": 0,
		"price": 800,
		"description": "Acts as a defensive wall that takes a bit of time to destroy."
	},
	Turret.TURRET_TYPE.BIRCH: {
		"scene": preload("uid://dsr172t8pg7nl"),
		"name": "Birch Tree",
		"projectile_speed": 0,
		"vision_range": 0,
		"price": 2000,
		"description": "Spreads leaves around to claim more forest ground."
	},
	Turret.TURRET_TYPE.GROW_MUSHROOM: {
		"scene": preload("uid://b6fxibbuh2g66"),
		"name": "Entoloma Hochstetteri",
		"projectile_speed": 0,
		"vision_range": 0,
		"price": 2250,
		"description": "Explodes when getting hit, slowly restores charges."
	},
	Turret.TURRET_TYPE.LEAVES: {
		"scene": preload("uid://bo7m55ray0m1w")
	},
}
