class_name TurretContainer
extends MarginContainer

signal dragging_turret(type: Turret.TURRET_TYPE)

const TURRET_BUTTON = preload("uid://brktw2fuqesdy")

@onready var description: PanelContainer = %Description
@onready var foldable_container: FoldableContainer = %FoldableContainer

var adding_turret: Turret.TURRET_TYPE = Turret.TURRET_TYPE.NONE

func _ready() -> void:
	description.hide()
	create_button(Turret.TURRET_TYPE.ACORN, load("res://Sprites/GrasslessTurrets/acorn_tree.png"))
	create_button(Turret.TURRET_TYPE.CHESTNUT, load("res://Sprites/GrasslessTurrets/chestnut_tree.png"))
	create_button(Turret.TURRET_TYPE.MUSHROOM_MINE, load("res://Sprites/GrasslessTurrets/fly_agaric.png"))
	create_button(Turret.TURRET_TYPE.ROOTS, load("res://Sprites/GrasslessTurrets/root_cluster.png"))
	create_button(Turret.TURRET_TYPE.CONE, load("res://Sprites/GrasslessTurrets/cone_tree.png"))
	create_button(Turret.TURRET_TYPE.BIRCH, load("res://Sprites/GrasslessTurrets/leaf_tree.png"))
	create_button(Turret.TURRET_TYPE.GROW_MUSHROOM, load("res://Sprites/GrasslessTurrets/entoloma_hochstetteri.png"))

func create_button(type: Turret.TURRET_TYPE, icon: Texture2D) -> void:
	var turret: TurretButton = TURRET_BUTTON.instantiate()
	turret.icon = icon
	turret.type = type
	turret.drag_started.connect(_on_button_drag_started)
	turret.mouse_entered.connect(_button_mouse_entered.bind(type))
	turret.mouse_exited.connect(_button_mouse_exited)
	%Buttons.add_child(turret)


func _on_button_drag_started(type: Turret.TURRET_TYPE) -> void:
	adding_turret = type
	dragging_turret.emit(type)
	foldable_container.fold()
	%DropContainer.show()


func _button_mouse_entered(type: Turret.TURRET_TYPE) -> void:
	description.set_turret(type)
	description.show()


func _button_mouse_exited() -> void:
	description.hide()
