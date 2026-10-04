# Ad Maiorem Dei Gloriam!
extends CharacterBody2D

const ACCELERATION = 800.0
const JUMP_VELOCITY = -300.0
const MAX_SPEED = 150.0

var was_on_floor: bool
var _direction: float = 0.0 
var _input_multiplier: float = 1.2
var _can_slide_jump: bool = false # This is a delayer copy of wall sliding, Helps with input buffer etc. 
var _is_wall_sliding: bool = false: # To see if it can jump
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
		_update_horizontal_velocity_by_input(delta)
		
	if Input.is_action_just_pressed("jump") && !TerminalManager.is_terminal_ui_open:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY 
			_squash(Vector2(1.4, 0.6))
		elif _can_slide_jump:
			var wall_normal: Vector2 = get_wall_normal()
			velocity.y = JUMP_VELOCITY * 0.8
			velocity.x = MAX_SPEED * wall_normal.x * 1.3

	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	was_on_floor = is_on_floor()
	move_and_slide()

func _update_horizontal_velocity_by_input(delta: float) -> void:
	_direction = Input.get_axis("go_left", "go_right") * _input_multiplier
	if _direction:
		%Sprite.flip_h = _direction < 0
		%Sprite.play("run")
		velocity.x += _direction * ACCELERATION * delta
	else:
		%Sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED)
	

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

func _lock_input(time: float) -> void:
	_input_multiplier = 0.0
	create_tween().tween_property(self, "_input_multiplier", 1.0, time).set_trans(Tween.TRANS_QUAD)
