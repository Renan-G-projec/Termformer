# Ad Maiorem Dei Gloriam
extends CanvasLayer

var transition_time: float = 0.5
var _in_transition: bool = false

var _progress: float = 0.0

func go_to_scene(scene: String) -> void:
	if _in_transition: return
	_in_transition = true
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "_progress", 1.0, transition_time)
	tween.tween_property(self, "_progress", 0.0, transition_time)
	await tween.step_finished
	
	get_tree().change_scene_to_file(scene)
	await get_tree().scene_changed
	
	%ColorRect.rotation_degrees = 180
	await tween.step_finished
	
	%ColorRect.rotation_degrees = 0
	
	_in_transition = false

func _process(delta: float) -> void:
	if !_in_transition: return
	var shader: ShaderMaterial = %ColorRect.material as ShaderMaterial
	if shader:
		shader.set_shader_parameter("animation_progress", _progress)
