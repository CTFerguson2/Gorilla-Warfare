class_name Round extends Node
signal end

var f1: Fighter
var f2: Fighter

func _init(f1_human: bool, f2_human: bool) -> void:
	if f1_human:
		f1 = HumanFighter.new()
	else:
		pass #f1 = AIFighter.new()
	f1.dead.connect(f1_dead)
	self.add_child(f1)
	if f2_human:
		f2 = HumanFighter.new()
	else:
		pass #f2 = AIFighter.new()
	f2.dead.connect(f2_dead)
	self.add_child(f2)

func _process(delta: float) -> void:
	pass

func f1_dead() -> void:
	end.emit(0)

func f2_dead() -> void:
	end.emit(1)
