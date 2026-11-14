class_name HumanFighter extends Fighter

var stick_buffer: Array[Vector2] = []
const STICK_BUFFER_LENGTH = 8
var input_buffer: Array[String] = []
const INPUT_BUFFER_LENGTH = 4
func _ready() -> void:
	stick_buffer.resize(STICK_BUFFER_LENGTH)
	stick_buffer.fill(Vector2.ZERO)
	input_buffer.resize(INPUT_BUFFER_LENGTH)
	input_buffer.fill("")

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("stick_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("stick_up"):
		direction += Vector2.UP
	if Input.is_action_pressed("stick_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("stick_right"):
		direction += Vector2.RIGHT
	stick_buffer.push_front(direction)
	stick_buffer.pop_back()
	var button = ""
	if Input.is_action_just_pressed("punch"):
		button = "PUNCH"
	elif Input.is_action_just_pressed("kick"):
		button = "KICK"
	elif Input.is_action_just_pressed("grab"):
		button = "GRAB"
	elif Input.is_action_just_pressed("taunt"):
		button = "TAUNT"
	input_buffer.push_front(button)
	input_buffer.pop_back()
	
	if not actionable:
		return
	
	var dash_direction: Vector2 = Vector2.ZERO
	var stick_release: bool = false
	for d in stick_buffer:
		if dash_direction == Vector2.ZERO:
			dash_direction = d
		elif d != dash_direction:  # average case is stick neutral, but could be performed by wobbling a diagonal
			stick_release = true
		elif stick_release:
			initiate_movement_action(dash_direction)
			return
	for i in input_buffer:
		if i != "":
			initiate_action(i)
			return
	var forward: Vector2 = facing_wrt_camera()
	if direction == Vector2.ZERO:
		return
	if direction.dot(forward) > 0:
		position += Vector3(forward.x, 0, forward.y) * WALK_SPEED * delta
	else:
		position += Vector3(-forward.x, 0, -forward.y) * WALK_SPEED * delta

func facing_wrt_camera() -> Vector2:
	var forward = global_basis.z.normalized()
	var camera = get_viewport().get_camera_3d()
	var relative_forward = camera.global_basis.inverse() * forward

	# face toward the opponent
	var to_opponent = get_parent().get_centerline()
	if relative_forward.dot(to_opponent) > 0:
		to_opponent *= -1
	look_at(position+to_opponent)
	# figure out which where you're facing relative to the camera
	return Vector2(relative_forward.x, relative_forward.z)

func initiate_movement_action(stick_direction: Vector2) -> void:
	var forward_v2 = facing_wrt_camera()
	# interpret stick direction
	var dot_product = stick_direction.dot(forward_v2)
	if dot_product > 0:
		initiate_action("DASH_FORWARD")
		print("dash forward")
	elif dot_product < 0:
		initiate_action("DASH_BACKWARD")
		print("dash backward")
	else:
		var cross_product_mag = (forward_v2.x * stick_direction.y) - (forward_v2.y * stick_direction.x)
		initiate_action("SIDESTEP_LEFT" if cross_product_mag < 0 else "SIDESTEP_RIGHT")  # TODO check that the directions are correct
		print("sidestep")
