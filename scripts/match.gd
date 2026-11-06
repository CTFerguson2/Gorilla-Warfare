extends Node

@export var round_number: int
@export var score: Vector2i

var round: Round

func _init(f1_human: bool = true, f2_human: bool = true) -> void:
	round = Round.new(f1_human, f2_human)
	round.end.connect(on_round_end)

func _ready() -> void:
	round_number = 1
	score = Vector2i(0,0)
	

func start_round(number: int) -> void:
	pass

func on_round_end(winner: bool) -> void:
	score[int(winner)]+=1
	if score.x >= 3 or score.y >= 3:
		victory(winner)
	else:
		start_round(++round_number)

func victory(winner: bool) -> void:
	print("player " + ("2" if winner else "1") + " wins!")
