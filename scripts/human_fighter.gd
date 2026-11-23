class_name HumanFighter extends Fighter

var controller_id = 0
var stick_buffer: Array[Vector2] = []
const STICK_BUFFER_LENGTH = 8
var input_buffer: Array[String] = []
const INPUT_BUFFER_LENGTH = 4
var forward_vector_at_action_start = Vector3.ZERO
var left_vector_at_action_start = Vector3.ZERO

func _ready() -> void:
	stick_buffer.resize(STICK_BUFFER_LENGTH)
	stick_buffer.fill(Vector2.ZERO)
	input_buffer.resize(INPUT_BUFFER_LENGTH)
	input_buffer.fill("")

func _physics_process(delta: float) -> void:
# Input is still placed in the buffer regardless of whether you're actionable or not
	var direction = Vector2.ZERO
	if is_action_pressed("stick_down"):
		direction += Vector2.DOWN
	if is_action_pressed("stick_up"):
		direction += Vector2.UP
	if is_action_pressed("stick_left"):
		direction += Vector2.LEFT
	if is_action_pressed("stick_right"):
		direction += Vector2.RIGHT
	stick_buffer.push_front(direction)
	stick_buffer.pop_back()
	var button = ""
	if is_action_pressed("punch"):
		button = "PUNCH"
	elif is_action_pressed("kick"):
		button = "KICK"
	elif is_action_pressed("grab"):
		button = "GRAB"
	elif is_action_pressed("taunt"):
		button = "TAUNT"
	input_buffer.push_front(button)
	input_buffer.pop_back()
	
	if not actionable:
		if forward_vector_at_action_start == Vector3.ZERO:
			forward_vector_at_action_start = -global_basis.z.normalized()
			left_vector_at_action_start = Vector3(forward_vector_at_action_start.z, 0, -forward_vector_at_action_start.x)
		match(current_action):
			"DASH_FORWARD":
				position += forward_vector_at_action_start * DASH_SPEED * delta
			"DASH_BACKWARD":
				position -= forward_vector_at_action_start * DASH_SPEED * delta
			"SIDESTEP_LEFT":
				position += left_vector_at_action_start * DASH_SPEED * delta
			"SIDESTEP_RIGHT":
				position -= left_vector_at_action_start * DASH_SPEED * delta
		return
	forward_vector_at_action_start = Vector3.ZERO
	left_vector_at_action_start = Vector3.ZERO
	
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
	if direction.dot(forward) > 0.5:
		position += Vector3(forward.x, 0, forward.y) * WALK_SPEED * delta
	elif direction.dot(forward) < -0.5:
		position += Vector3(-forward.x, 0, -forward.y) * WALK_SPEED * delta

func is_action_pressed(action: String) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton:
			return Input.is_joy_button_pressed(controller_id, event.button_index)
		if event is InputEventJoypadMotion:
			var axis_value = Input.get_joy_axis(controller_id, event.axis)
			if event.axis_value > 0:
				return axis_value > event.axis_value
			else:
				return axis_value < event.axis_value
	return false

func facing_wrt_camera() -> Vector2:
	var forward = -global_basis.z.normalized()
	var camera = get_viewport().get_camera_3d()
	var relative_forward = camera.global_basis.inverse() * forward

	# face toward the opponent
	look_at(get_parent().get_opponent_position(fighter_number), Vector3.UP)
	# figure out which where you're facing relative to the camera
	return Vector2(relative_forward.x, relative_forward.z)

func initiate_movement_action(stick_direction: Vector2) -> void:
	var forward_v2 = facing_wrt_camera()
	# interpret stick direction
	var dot_product = stick_direction.dot(forward_v2)
	if dot_product > 0.5:
		initiate_action("DASH_FORWARD")
		print("dash forward")
	elif dot_product < -0.5:
		initiate_action("DASH_BACKWARD")
		print("dash backward")
	else:
		var cross_product_mag = (forward_v2.x * stick_direction.y) - (forward_v2.y * stick_direction.x)
		initiate_action("SIDESTEP_LEFT" if cross_product_mag < 0 else "SIDESTEP_RIGHT")  # TODO check that the directions are correct
		print("sidestep")
