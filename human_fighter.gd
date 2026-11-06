class_name HumanFighter extends Fighter


var stick_buffer: Array[Vector2i] = []
func _start() -> void:
	stick_buffer.resize(8)
	stick_buffer.fill(Vector2i.ZERO)
func _physics_process(delta: float) -> void:
	var direction = Vector2i.ZERO
	if Input.is_action_pressed("stick_down"):
		direction += Vector2i.DOWN
	if Input.is_action_pressed("stick_up"):
		direction += Vector2i.UP
	if Input.is_action_pressed("stick_left"):
		direction += Vector2i.LEFT
	if Input.is_action_pressed("stick_right"):
		direction += Vector2i.RIGHT
	stick_buffer.push_front(direction)
	stick_buffer.pop_back()
	if state.current_action:
		return
	#TODO parse inputs into actions
	
