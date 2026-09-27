# Ad Maiorem Dei Gloriam!
extends Node2D

@export_file_path("level*.tscn") var target_level_path: String
@onready var area: Area2D = $Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _is_interacting() && target_level_path:
		get_tree().change_scene_to_file(target_level_path)

func _is_interacting() -> bool:
	# Overlapping bodies. The area collision mask garantees that only the player will return true
	return !TerminalManager.is_terminal_ui_open && Input.is_action_just_pressed("interact") && area.has_overlapping_bodies()
