class_name Round extends Node
signal end

const human_scene = preload("res://scenes/human_fighter.tscn")
# const ai_scene = preload("res://scenes/ai_fighter.tscn")

var f1: Fighter
var f2: Fighter
var number: int

func _init(f1_human: bool = true, f2_human: bool = true) -> void:
	f1 = human_scene.instantiate()
	f1.fighter_number = 0
	f1.controller_id = 0
	f1.dead.connect(f1_dead)
	self.add_child(f1)
	if f2_human:
		f2 = human_scene.instantiate()
		f2.fighter_number = 1
		f2.controller_id = 1
	else:
		pass #f2 = ai_scene.instantiate()
	f2.dead.connect(f2_dead)
	self.add_child(f2)

func _ready() -> void:
	f1.position = Vector3(-5,0,-10)
	f1.rotation = Vector3(0,PI/2,0)
	f2.position = Vector3(5,0,-10)
	f2.rotation = Vector3(0,-PI/2,0)

func _process(delta: float) -> void:
	var center = (f1.position + f2.position) * 0.5
	var f1_to_f2 = f2.position - f1.position
	var normal = Vector3(-f1_to_f2.z, 3, f1_to_f2.x)  # y coord determines the angle from which the angle looks at the match
#	var target = center + (normal * f1_to_f2.length() * 0.1)
#	$Pivot/Camera3D.position += target - $Pivot/Camera3D.position * 0.1
#	$Pivot/Camera3D.look_at(center, Vector3(0,1,0))
	$Pivot.position = center
	$Pivot/Camera3D.position.z = f1_to_f2.length()

func get_centerline() -> Vector3:
	return f1.position - f2.position

func get_opponent_position(player: int) -> Vector3:
	return f1.position if player == 1 else f2.position

func f1_dead() -> void:
	end.emit(0)

func f2_dead() -> void:
	end.emit(1)
