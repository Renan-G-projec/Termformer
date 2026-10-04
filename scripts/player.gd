# Ad Maiorem Dei Gloriam!
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var was_on_floor: bool
var _direction: float = 0.0 
var _can_slide_jump: bool = false
var _is_wall_sliding: bool = false:
	set(val):
		var was_wall_sliding: bool = _is_wall_sliding
		_is_wall_sliding = val
		if !val && was_wall_sliding:
			await get_tree().create_timer(0.3).timeout
		_can_slide_jump = val
			
@onready var _initial_scale: Vector2 = scale

func _physics_process(delta: float) -> void:
	_update_vertical_velocity(delta)

	if !TerminalManager.is_terminal_ui_open: 
		_update_horizontal_velocity_by_input()
		
	if Input.is_action_just_pressed("jump") && !TerminalManager.is_terminal_ui_open:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY 
			_squash(Vector2(1.4, 0.6))
		elif _can_slide_jump:
			var wall_normal: Vector2 = get_wall_normal()
			velocity.y = JUMP_VELOCITY * 0.5
			velocity.x = SPEED * 2 * wall_normal.x

	was_on_floor = is_on_floor()
	move_and_slide()

func _update_horizontal_velocity_by_input() -> void:
	_direction = Input.get_axis("go_left", "go_right")
	if _direction:
		%Sprite.flip_h = _direction < 0
		%Sprite.play("run")
		velocity.x = _direction * SPEED
	else:
		%Sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _update_vertical_velocity(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
	elif !was_on_floor:
		_squash(Vector2(1.4, 0.6))
	if !is_on_floor() && velocity.y > 0 && _direction && is_on_wall():
		_is_wall_sliding = true
		velocity.y += velocity.y * (-0.3)
	else:
		_is_wall_sliding = false 

func _squash(scale: Vector2) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(%Sprite, "scale", scale, 0.01).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%Sprite, "scale", _initial_scale, 0.1).set_trans(Tween.TRANS_QUAD)
	
