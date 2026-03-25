# EvidenceMinigame.gd
class_name EvidenceMinigame
extends Node



@export var max_lives: int = 3

var current_lives: int
var current_stage: String = ""
var current_step_index: int = 0
var total_losses: int = 0

#this is so that only signals with these are handled
const GAME_SIGNAL_PREFIXES = ["choice_", "what_", "who_", "noisemaker_", "purpose_", "place_", "blackout_", "move_"]

var handling_wrong_step: bool = false  # stops multiple triggers

# Each stage has its own steps
var stages = {
	"stage_1": [
		{
			"correct_choice": "choice_hobbyist store",
			"retry_label": "stage1_step1" #where to restart from
		},
	
	],

	"stage_2": [
		{
			"correct_choice": "choice_1_kevin",
			"retry_label": "stage2_step1"  

		}
	],

	"stage_3": [
		{
			"correct_choice": "what_loud",
			"retry_label": "what_happened"  

		},
		{
			"correct_choice": "who_iris",
			"retry_label": "who_felt"  
	
		},
		{
			"correct_choice": "noisemaker_counter",
			"retry_label": "where_noisemaker"  
		},
		{
			"correct_choice": "purpose_deafen",
			"retry_label": "purpose_noisemaker"  
		},
		{
			"correct_choice": "place_supply",
			"retry_label": "place"
		},
		{
			"correct_choice": "blackout_surge",
			"retry_label": "cause_blackout"
		},
		{
			"correct_choice": "move_touch",
			"retry_label": "arrows_drawing"

		},
	]
}


func _ready():
	current_lives = max_lives
	
	if not Dialogic.signal_event.is_connected(_on_choice_made):
		Dialogic.signal_event.connect(_on_choice_made)
	start("stage_1")


# 🔥 START A STAGE
func start(stage_name: String):
	current_stage = stage_name
	current_step_index = 0
	current_lives = max_lives
	
	# Start the timeline
	Dialogic.start(stage_name)


func _on_choice_made(choice_id: String):
	
	#bad practice ik cuz these arent even choices but i needed this working. 
	#this stuff is just checking for end signals:
	
	if choice_id.ends_with("_complete"):
		if choice_id == "stage_1_complete":
			start("stage_2")
		if choice_id == "stage_2_complete":
			start("stage_3")
		if choice_id == "stage_3_complete":
			_win()
			
	
	if current_stage == "":
		return
	
	var step = stages[current_stage][current_step_index]
	var correct_choice = step["correct_choice"]

	if choice_id == correct_choice:
		_correct_step()
	else:
		_wrong_step()



func _correct_step():
	current_step_index += 1
	
	#if current_step_index >= stages[current_stage].size(): 
		#_stage_complete()
	#else:
		
		#Dialogic.next()
		



func _wrong_step():
	
	if handling_wrong_step:
		return
	handling_wrong_step = true
	current_lives -= 1
	
	if current_lives <= 0:
		_lose()
		return
	
	var step = stages[current_stage][current_step_index]
	var label = step.get("retry_label", "")
	
	if label != "":
		Dialogic.Jump.jump_to_label(label)
	
		# give a tiny delay so signal doesn't immediately fire again
	await get_tree().process_frame
	handling_wrong_step = false


#func _stage_complete():
	#print("Stage complete: ", current_stage)
	#
	#match current_stage:
		#"stage_1":
			#start("stage_2")
		#"stage_2":
			#start("stage_3")
		#"stage_3":
			#_win()


func _win():
	print("Minigame WIN")
	


func _lose():
	print(current_lives)

	print("Minigame LOSE")
	total_losses += 1
	current_step_index = 0
	current_lives = max_lives
	print(current_lives)
	
	Dialogic.start(current_stage)
