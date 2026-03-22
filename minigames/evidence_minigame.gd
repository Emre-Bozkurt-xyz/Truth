
class_name EvidenceMinigame
extends Node



var current_stage: int = 0
var lives: int = 3

var stages = [
	{
		"correct_evidence": "photo_night",
		"dialogue": "stage_1"
		
		
	}
	
]


func start():
	current_stage = 0
	lives = 3
	_start_stage()
	
func _start_stage():
	var stage = stages[current_stage]
	Dialogic.start(stage["dialogue"])
	
func _on_choice_made(choice):
	var selected_id = _map_choice_to_evidence(choice)
	_check_answer(selected_id)
	
func _check_answer(selected_id):
	var correct = stages[current_stage]["correct_evidence"]
	if selected_id == correct:
		_correct()
	else:
		_wrong()
		
func _correct():
	current_stage += 1
	if current_stage >= stages.size():
		_win()

func _wrong():
	lives -= 1
	if lives <= 0:
		_lose()
	else:
		Dialogic.start("wrong_answer_dialogue")
	


func _win():
	print("winner")

func _lose():
	print("got gaslit")
	
	
