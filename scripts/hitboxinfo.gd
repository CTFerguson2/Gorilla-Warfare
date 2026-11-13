class_name HitboxInfo extends Node
var position: Vector3
var radius: float
var start_time: float
var end_time: float
func _init(_position: Vector3, _radius: float, _start_time: float, _end_time: float):
	position = _position
	radius = _radius
	start_time = _start_time
	end_time = _end_time
