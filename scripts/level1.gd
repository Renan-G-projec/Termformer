extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_terminal"):
		TerminalManager.request_toggle_ui.emit()
	if Input.is_action_just_pressed("ui_cancel"):
		TerminalManager.request_close_ui.emit()
