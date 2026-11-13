class_name Fighter extends Node3D
signal dead

const WALK_SPEED: int = 25
const DASH_SPEED: int = 40

# var action_types = {
#	"DASH_FORWARD" : 1,
#	"DASH_BACKWARD" : 2,
#	"SIDESTEP_IN" : 3,
#	"SIDESTEP_OUT" : 4,
#	"PUNCH" : 5,
#	"KICK" : 6,
#	"GRAB" : 7,
#	"TAUNT" : 8,
#	"HITSTUN" : 9
# }

@export var life: int = 3
@export var actionable: bool = true

var active_hitboxes: bool = false
var active_animation: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if life <= 0:
		dead.emit()
	actionable = (not active_hitboxes) and (not active_animation)

func initiate_action(action_type: String):
	$HitboxSpawner.play(action_type)
	active_hitboxes = true
#	$AnimationPlayer.play(action_type)
#	active_animation = true

func _on_hitbox_spawner_complete() -> void:
	active_hitboxes = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	active_animation = false
