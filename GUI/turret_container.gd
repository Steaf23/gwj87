class_name TurretContainer
extends MarginContainer

signal dragging_turret(type: Turret.TURRET_TYPE)

const TURRET_BUTTON = preload("uid://brktw2fuqesdy")

var adding_turret: Turret.TURRET_TYPE = Turret.TURRET_TYPE.NONE

func _ready() -> void:
	create_button(Turret.TURRET_TYPE.ACORN, load("res://Sprites/acorn_tree.png"))
	create_button(Turret.TURRET_TYPE.CHESTNUT, load("res://Sprites/chestnut_tree.png"))
	create_button(Turret.TURRET_TYPE.CONE, load("res://Sprites/cone_tree.png"))
	create_button(Turret.TURRET_TYPE.MUSHROOM_MINE, load("res://Sprites/fly_agaric.png"))
	create_button(Turret.TURRET_TYPE.GROW_MUSHROOM, load("res://Sprites/entoloma_hochstetteri_5.png"))
	create_button(Turret.TURRET_TYPE.ROOTS, load("res://Sprites/root_cluster.png"))
	create_button(Turret.TURRET_TYPE.BIRCH, load("res://Sprites/leaf_tree.png"))


func create_button(type: Turret.TURRET_TYPE, icon: Texture2D) -> void:
	var turret: TurretButton = TURRET_BUTTON.instantiate()
	turret.icon = icon
	turret.type = type
	turret.drag_started.connect(_on_button_drag_started)
	%Buttons.add_child(turret)


func _on_button_drag_started(type: Turret.TURRET_TYPE) -> void:
	adding_turret = type
	dragging_turret.emit(type)
	$PanelContainer/FoldableContainer.fold()
	%DropContainer.show()
