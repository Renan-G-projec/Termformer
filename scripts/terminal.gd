# Ad Maiorem Dei Gloriam!
class_name Terminal
extends Sprite2D

@export var connected_nodes: Array[Node2D] = []

var _focused: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	_focused = true
	%FocusEffect.visible = _focused
	TerminalManager.connect_serial_nodes(connected_nodes)

func _on_area_2d_body_exited(body: Node2D) -> void:
	_focused = false
	%FocusEffect.visible = _focused
	TerminalManager.disconnect_serial_nodes()

func _process(delta: float) -> void:
	if !_focused: return
	if Input.is_action_just_pressed("toggle_terminal"):
		TerminalManager.request_open_ui.emit()
	elif Input.is_action_just_pressed("ui_cancel"):
		TerminalManager.request_close_ui.emit()
