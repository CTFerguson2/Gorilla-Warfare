class_name Fighter extends Node3D
signal dead

const WALK_SPEED: int = 25
const DASH_SPEED: int = 40

enum action_types {
	DASH_FORWARD,
	DASH_BACKWARD,
	SIDESTEP_IN,
	SIDESTEP_OUT,
	PUNCH,
	KICK,
	GRAB,
	TAUNT,
	HITSTUN
}

class State:
	var life: int = 3
	var current_action: Action = null
	func set_current_action(action_type: int):
		current_action = Action.new(action_type)
		current_action.complete.connect(on_current_action_complete)
		current_action.play()
	func on_current_action_complete():
		current_action = null
var state: State = State.new()

func _process(delta: float) -> void:
	if state.life <= 0:
		dead.emit()
