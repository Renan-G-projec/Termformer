# Ad Maiorem Dei Gloriam!
extends Node2D

@export_file_path("level*.tscn") var target_level_path: String
@export var unlocked: bool = true
@onready var area: Area2D = $Area2D

var player_ref: Player = null

func _ready() -> void:
	_sync_sprite_light()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _is_interacting():
		if unlocked: _go_to_target()
		else: _try_consume_key()

func _go_to_target() -> void:
	assert(FileAccess.file_exists(target_level_path), "There is not a next file. If the game should end, transition must be made for the end scene.")
	Transition.go_to_scene(target_level_path)

func _is_interacting() -> bool:
	# Overlapping bodies. The area collision mask garantees that only the player will return true
	return !TerminalManager.is_terminal_ui_open && Input.is_action_just_pressed("interact") && area.has_overlapping_bodies()

func _try_consume_key() -> void:
	if player_ref:
		if player_ref.has_key:
			player_ref.has_key = false
			unlocked = true
			_start_animation()
			_squash(Vector2(1.1, 0.9), Color.LIME)
		else:
			_squash(Vector2(0.8, 0.99), Color.RED)

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_ref = body as Player
	if unlocked:
		_start_animation()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if unlocked:
		_end_animation()
	
func _start_animation() -> void:
	%Sprite.play()

func _end_animation() -> void:
	%Sprite.play_backwards()

func _on_sprite_frame_changed() -> void:
	_sync_sprite_light()

func _sync_sprite_light() -> void:
	var animation_progress: float = 1.0 / %Sprite.sprite_frames.get_frame_count("default") * %Sprite.frame
	%PointLight2D.energy = animation_progress
	%PointLight2D.texture_scale = 2 * animation_progress

func _squash(_scale: Vector2, light_fade_color: Color = Color.TRANSPARENT):
	var orig_color: Color = %PointLight2D.color
	var orig_scale: float = %PointLight2D.texture_scale
	
	%PointLight2D.energy = 0.4
	%PointLight2D.texture_scale = 2.4
	
	%PointLight2D.color = light_fade_color
	%Sprite.scale = _scale
	
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(%Sprite, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(%PointLight2D, "energy", 0.0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(%PointLight2D, "texture_scale", orig_scale, 0.7).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	%PointLight2D.color = orig_color
