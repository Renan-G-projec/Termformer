# Ad Maiorem Dei Gloriam!
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") && !TerminalManager.is_terminal_ui_open && is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !TerminalManager.is_terminal_ui_open: 
		_update_horizontal_velocity_by_input() 

	move_and_slide()

func _update_horizontal_velocity_by_input() -> void:
	var direction := Input.get_axis("go_left", "go_right")
	if direction:
		%Sprite.flip_h = direction < 0
		%Sprite.play("run")
		velocity.x = direction * SPEED
	else:
		%Sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
