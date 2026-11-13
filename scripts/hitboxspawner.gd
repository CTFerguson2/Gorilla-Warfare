class_name HitboxSpawner extends Node3D
signal complete

var time: float
var action_type: String
var hitboxes: Array[HitboxInfo] # sorted by start time
var hitbox_end_queue: Array[Area3D] # will be sorted by soonest ending

func _ready() -> void:
	reset()

func reset() -> void:
	self.set_physics_process(false)
	time = 0.0
	# these failsafes are here for when an action is interrupted (e.g. hitstun)
	action_type = ""
	hitboxes.clear()
	while not hitbox_end_queue.is_empty():
		hitbox_end_queue.pop_front().queue_free()

func play(_action_type: String) -> void:
	action_type = _action_type
	hitboxes = get_hitboxes(action_type)
	self.set_physics_process(true)

func _physics_process(delta: float) -> void:
	if action_type == "":
		print("this code should not execute")
		return
	time += delta
# create new hitboxes on their start frame
	while true:
		if hitboxes.is_empty() or hitboxes[0].start_time > time:
			break
		var hitbox = hitboxes.pop_front()
		var area = Area3D.new()
		var collision = CollisionShape3D.new()
		var sphere = SphereShape3D.new()
		sphere.radius = hitbox.radius
		collision.shape = sphere
		area.add_child(collision)
		area.position = hitbox.position
		area.set_meta("end_time", hitbox.end_time)
		area.set_meta("attack_type", action_type)
		var i: int = 0;
		while i < hitbox_end_queue.size():
			if hitbox.end_time < hitbox_end_queue[i].get_meta("end_time"):
				break
			i+=1
		hitbox_end_queue.insert(i, area)
		print("spawned a hitbox")
# destroy hitboxes on their end frame
	while true:
		if hitbox_end_queue.is_empty() and hitboxes.is_empty():
			reset()
			complete.emit()
			return
		if hitbox_end_queue.is_empty() or hitbox_end_queue[0].get_meta("end_time") > time:
			break
		var area = hitbox_end_queue.pop_front()
		area.queue_free()

func get_hitboxes(_action_type: String) -> Array[HitboxInfo]:
	var ret: Array[HitboxInfo] = []
	match _action_type:
		"PUNCH":
			ret =	[
					HitboxInfo.new(Vector3(0,5,10), 10, 0.5, 1.0),
					HitboxInfo.new(Vector3(10,15,20), 5, 0.8, 1.5),
					HitboxInfo.new(Vector3(2,4,8), 16, 1.3, 1.5),
					HitboxInfo.new(Vector3(1,13,2), 4, 1.9, 2.3),
					HitboxInfo.new(Vector3(0,0,0), 1, 2.0, 2.5)
					]
		"KICK":
			pass
		"GRAB":
			pass
		"TAUNT":
			pass
	return ret
