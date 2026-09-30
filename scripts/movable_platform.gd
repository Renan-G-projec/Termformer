# Ad Maiorem Dei Gloriam!
class_name MovablePlatform
extends Path2D

@export var transition_type: Tween.TransitionType = Tween.TRANS_CUBIC
@export var time_to_finish: float = 2.0

@onready var tween: Tween = create_tween()
var active: bool = true:
	set(val):
		if val:
			tween.play()
		else:
			tween.pause()
		active = val

func _ready() -> void:
	tween.set_loops()
	tween.tween_property($PathFollow2D, "progress_ratio", 1.0, time_to_finish).set_trans(transition_type)
	tween.tween_property($PathFollow2D, "progress_ratio", 0.0, time_to_finish).set_trans(transition_type)

func toggle_disable() -> void:
	
	active = !active
