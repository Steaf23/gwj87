class_name Turret
extends StaticBody2D

enum TURRET_TYPE {
	NONE,
	ACORN,
	CHESTNUT,
	CONE,
	ELDER,
	DEAD,
	MUSHROOM_MINE,
	GROW_MUSHROOM,
	ROOTS,
	BIRCH,
	LEAVES,
}

signal died()
signal target_changed(new_target: Enemy)
signal turret_clicked()

@export var max_hp: int = 3
@export var type: Turret.TURRET_TYPE

@onready var hp: int = max_hp:
	set(value):
		hp = value
		$HpBar.current_hp = hp

@onready var world: Node2D

var visible_targets: Array[Enemy] = []
var current_target: Enemy = null

var dead = false

func _ready() -> void:
	$HpBar.max_hp = max_hp
	$HpBar.current_hp = hp

func damage(amount: int) -> void:
	if dead:
		return
	hp = clamp(hp - amount, 0, max_hp)
	if hp <= 0:
		died.emit()
		if type == TURRET_TYPE.ELDER:
			SoundManager.play_sfx(Sounds.ELDER_DEATH)
		elif type != TURRET_TYPE.MUSHROOM_MINE:
			SoundManager.play_sfx(Sounds.TURRET_DEATH, 0.5)


func _on_vision_range_body_entered(body: Node2D) -> void:
	if not body in visible_targets and body is Enemy:
		visible_targets.append(body)
		update_target()


func _on_vision_range_body_exited(body: Node2D) -> void:
	if body in visible_targets:
		visible_targets.erase(body)
		update_target()
	

func update_target() -> void:
	var has_target = not visible_targets.is_empty()
	if has_target:
		current_target = visible_targets.front()
	else:
		current_target = null
	
	target_changed.emit(current_target)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		turret_clicked.emit()
