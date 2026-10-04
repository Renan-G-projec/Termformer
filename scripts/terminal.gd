# Ad Maiorem Dei Gloriam!
class_name Terminal
extends Node2D

@export var connected_nodes: Array[Node2D] = []

@onready var _initial_scale: Vector2 = scale

var _focused: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	_focused = true
	TerminalManager.connect_serial(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	_focused = false
	TerminalManager.disconnect_serial()
	TerminalManager.request_close_ui.emit()

func _process(delta: float) -> void:
	if !_focused: return
	if Input.is_action_just_pressed("interact"):
		TerminalManager.request_open_ui.emit()
	if Input.is_action_pressed("ui_cancel"):
		TerminalManager.request_close_ui.emit()

func squash(scale: Vector2 = Vector2(1.1, 0.9)) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(%Sprite, "scale", scale, 0.01).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%Sprite, "scale", _initial_scale, 0.2).set_trans(Tween.TRANS_QUAD)
	
