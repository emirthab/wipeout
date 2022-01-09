extends KinematicBody

var velocity = Vector3()
var direction = Vector3()
var speed = 13
var acceleration = 5
var air_acceleration : float = 5
export var mouse_sensivity = 0.07
export var jump_power = 180
var max_terminal_velocity : float = 54
var gravity : float = 0.98
var y_velocity : float

func _ready():
	$Model/AnimationPlayer.play("idle")

func handle_movement(delta):
	
	direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	direction = direction.normalized()
	velocity = direction * speed

	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if Input.is_action_just_pressed("move_jump"):
		y_velocity = jump_power
		$Model/AnimationPlayer.play("jump")

	
	velocity.y = y_velocity
	move_and_slide(velocity,Vector3.UP)

func _physics_process(delta):
	handle_movement(delta)

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensivity))
		$Pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensivity))
		$Pivot.rotation.x = clamp($Pivot.rotation.x,deg2rad(-90),deg2rad(90))
	
	if Input.is_key_pressed(KEY_ESCAPE) && just_pressed:
		print(Input.get_mouse_mode())
		if Input.get_mouse_mode() == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		elif Input.get_mouse_mode() == 2:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
