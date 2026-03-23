
class_name EvidenceMinigame
extends Node



var current_stage: int = 0
@export var lives: int = 3



var stages = [
	{
		"correct_evidence": "photo_night",
		"dialogue": "stage_1"
		
		
	}
	
]


func _ready():
	if not Dialogic.signal_event.is_connected(_on_choice_made):
		Dialogic.signal_event.connect(_on_choice_made)
		
func start():
	current_stage = 0
	lives = 3
	_start_stage()
	Dialogic.signal_event.connect(_on_choice_made)

	
func _start_stage():
	var stage = stages[current_stage]
	Dialogic.start(stage["dialogue"])
	
func _on_choice_made(choice): #separate function in case i wanted to do a map choice to evidence function or smt
	_check_answer(choice)
	
func _check_answer(selected_id):
	var correct = stages[current_stage]["correct_evidence"]
	if selected_id == correct:
		_correct()
	else:
		_wrong()
		
func _correct():
	current_stage += 1
	if current_stage >= stages.size():
		Dialogic.signal_event.emit("win")
	else:
		Dialogic.signal_event.emit("next_stage")

func _wrong():
	lives -= 1
	if lives <= 0:
		Dialogic.signal_event.emit("lose")
	else:
		Dialogic.signal_event.emit("retry")
	


	
