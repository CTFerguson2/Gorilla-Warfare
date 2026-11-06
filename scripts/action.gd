class_name Action extends Node
signal complete

class HitBoxInfo:
	var start_time: float
	var end_time: float
	var position: Vector3
	var radius: float
	var damage: int

var action_type
var animation: String
var hitboxes: Array[HitBoxInfo]
var hitbox_end_queue: Array[Area3D]
var time: float

func _init(_action_type: int) -> void:
	action_type = _action_type

func _ready() -> void:
	time = 0.0

func _process(delta: float) -> void:
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
			if hitbox.end_time < hitbox_end_queue[i]:
				break
			i+=1
		hitbox_end_queue.insert(i, area)
# destroy hitboxes on their end frame
	while true:
		if hitbox_end_queue.is_empty() or hitbox_end_queue[0].get_meta("end_time") > time:
			break
		var area = hitbox_end_queue.pop_front()
		area.queue_free()
