# Ad Maiorem Dei Gloriam!
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var was_on_floor: bool
var _direction: float = 0.0 
@onready var _initial_scale: Vector2 = scale

func _physics_process(delta: float) -> void:
	_update_vertical_velocity(delta)

	if Input.is_action_just_pressed("jump") && !TerminalManager.is_terminal_ui_open && is_on_floor():
		velocity.y = JUMP_VELOCITY
		_squash(Vector2(1.4, 0.6))

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !TerminalManager.is_terminal_ui_open: 
		_update_horizontal_velocity_by_input()  
	
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
		velocity.y += velocity.y * (-0.3)

func _squash(scale: Vector2) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(%Sprite, "scale", scale, 0.01).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%Sprite, "scale", _initial_scale, 0.1).set_trans(Tween.TRANS_QUAD)
	
