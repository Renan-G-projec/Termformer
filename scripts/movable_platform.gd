# Ad Maiorem Dei Gloriam!
class_name MovablePlatform
extends Path2D

@export var transition_type: Tween.TransitionType = Tween.TRANS_CUBIC
@export var time_to_finish: float = 2.0
@export var time_to_pause: float = 0.4

@onready var tween: Tween = create_tween()
var _paused: bool = false

func _ready() -> void:
	tween.set_loops()	
	tween.tween_property(%PathFollow2D, "progress_ratio", 1.0, time_to_finish).set_trans(transition_type).set_ease(Tween.EASE_OUT)
	tween.tween_property(%PathFollow2D, "progress_ratio", 0.0, time_to_finish).set_trans(transition_type).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(0.7).timeout
	toggle_disable()

func toggle_disable() -> void:
	if _paused:
		tween.play()
	else:
		tween.pause()
