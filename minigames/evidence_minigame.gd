# EvidenceMinigame.gd
class_name EvidenceMinigame
extends Node

@export var max_lives: int = 3
var current_lives: int
var current_step_index: int = 0

# Define your steps: each step has a correct choice and the event index in the timeline
# event_index should match the index of the first Text Event or Choice Node of the step in Dialogic
var steps = [
	
	
	#stage 1 steps
	{
		"correct_choice": "choice_cinema",
		"event_index": 10, # index of Choice Node for "Where did we all go?"
		"retry_index": 10  # where to restart if wrong
	},
	{
		"correct_choice": "choice_note_secret",
		"event_index": 20, # next step's choice node index
		"retry_index": 20
	}
	
	
	
	#stage 2 steps
]

func _ready():
	current_lives = max_lives
	# Connect to Dialogic signal_event
	if not Dialogic.signal_event.is_connected(_on_choice_made):
		Dialogic.signal_event.connect(_on_choice_made)

func start():
	current_lives = max_lives
	current_step_index = 0
	_start_step(current_step_index)

# Starts a step at the specific event in the timeline
func _start_step(step_index: int):
	current_step_index = step_index
	var event_index = steps[step_index]["event_index"]
	Dialogic.jump_to_event(event_index)

# Called whenever the player chooses an option in Dialogic
func _on_choice_made(choice_id: String):
	var correct_choice = steps[current_step_index]["correct_choice"]
	if choice_id == correct_choice:
		_correct_step()
	else:
		_wrong_step(choice_id)

func _correct_step():
	current_step_index += 1
	if current_step_index >= steps.size():
		_win()
	else:
		# Move to next step in timeline
		_start_step(current_step_index)

func _wrong_step(wrong_choice_id: String):
	current_lives -= 1
	if current_lives <= 0:
		_lose()
		return

	# Jump back to the retry_index for this wrong answer
	var retry_index = steps[current_step_index].get("retry_index", steps[current_step_index]["event_index"])
	_start_step(current_step_index) # or use retry_index if different
	# Optional: show a feedback line or dialogue
	# Dialogic.start("wrong_answer_dialogue")  # if you have a separate feedback timeline

func _win():
	print("Evidence Minigame: Player wins!")
	Dialogic.signal_event.emit("win")  # optional: let other scripts know

func _lose():
	print("Evidence Minigame: Player lost!")
	Dialogic.signal_event.emit("lose") # optional: let other scripts know
