# Ad Maiorem Dei Gloriam!
class_name Terminal
extends AnimatedSprite2D

@export var connected_nodes: Array[Node2D] = []

var _focused: bool = false

func _ready() -> void:
	%FocusEffect.texture = sprite_frames.get_frame_texture("idle", 0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	_focused = true
	%FocusEffect.visible = _focused
	TerminalManager.connect_serial_nodes(connected_nodes)

func _on_area_2d_body_exited(body: Node2D) -> void:
	_focused = false
	%FocusEffect.visible = _focused
	TerminalManager.disconnect_serial_nodes()
	TerminalManager.request_close_ui.emit()

func _process(delta: float) -> void:
	if !_focused: return
	if Input.is_action_just_pressed("interact"):
		TerminalManager.request_open_ui.emit()
	if Input.is_action_pressed("ui_cancel"):
		TerminalManager.request_close_ui.emit()
