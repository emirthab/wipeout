extends KinematicBody

var velocity = Vector3()
var direction = Vector3()
var speed = 13
var acceleration = 5
var air_acceleration : float = 5
export var mouse_sensivity = 0.004
export var jump_power = 25
var max_terminal_velocity : float = 54
var gravity : float = 0.98
var y_velocity : float
var jumpTimer : float

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func handle_movement(delta):
	direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= $Pivot.transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		direction += $Pivot.transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= $Pivot.transform.basis.x
	
	elif Input.is_action_pressed("move_right"):
		direction += $Pivot.transform.basis.x
	
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	direction = direction.normalized()
	velocity = direction * speed

	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if not is_on_floor():
		jumpTimer += delta
	else:
		jumpTimer = 0

	if Input.is_action_just_pressed("move_jump") and jumpTimer < 0.1:
		$Model/AnimationPlayer.play("jump")
		y_velocity = jump_power
	elif (velocity.x != 0 || velocity.z != 0) && y_velocity == -0.01:
		$Model/AnimationPlayer.play("run")
	elif y_velocity == -0.01:
		$Model/AnimationPlayer.play("idle")

	velocity.y = y_velocity
	move_and_slide(velocity,Vector3.UP)
	if direction != Vector3(0,0,0):
		$Model.rotation.y = lerp_angle($Model.rotation.y, atan2(direction.x,direction.z),delta * 5)

func _physics_process(delta):
	if Input.get_mouse_mode() == 2:
		handle_movement(delta)

func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() != 0:
		var resultant = sqrt((event.relative.x * event.relative.x )+ (event.relative.y * event.relative.y ))
		var rot = Vector3(-event.relative.y,-event.relative.x,0).normalized()
		$Pivot.rotate_object_local(rot , resultant * mouse_sensivity)
		$Pivot.rotation.z = clamp($Pivot.rotation.z,deg2rad(-0),deg2rad(0))
		$Pivot.rotation.x = clamp($Pivot.rotation.x,deg2rad(-30),deg2rad(30))


