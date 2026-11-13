class_name Round extends Node
signal end

const human_scene = preload("res://scenes/human_fighter.tscn")
# const ai_scene = preload("res://scenes/ai_fighter.tscn")

var f1: Fighter
var f2: Fighter
var number: int

func _init(f1_human: bool = true, f2_human: bool = true) -> void:
	if f1_human:
		f1 = human_scene.instantiate()
	else:
		pass #f1 = ai_scene.instantiate()
	f1.dead.connect(f1_dead)
	self.add_child(f1)
	if f2_human:
		f2 = human_scene.instantiate()
	else:
		pass #f2 = ai_scene.instantiate()
	f2.dead.connect(f2_dead)
	self.add_child(f2)

func _process(delta: float) -> void:
	pass

func f1_dead() -> void:
	end.emit(0)

func f2_dead() -> void:
	end.emit(1)
