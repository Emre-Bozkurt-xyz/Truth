# EvidenceMinigame.gd
class_name EvidenceMinigame
extends Node


@export var mistake_timeline: String = "mistake_reaction"  # for when messing up but still have lives
@export var loss_timeline: String = "loss_reaction"  # for when running out of lives
@export var max_lives: int = 3

var current_lives: int
var current_stage: String = ""
var current_step_index: int = 0
var total_losses: int = 0

#this is so that only signals with these are handled
const GAME_SIGNAL_PREFIXES = ["choice_", "what_", "who_", "noisemaker_", "purpose_", "place_", "blackout_", "move_"]

var handling_wrong_step: bool = false  # stops multiple triggers
var handling_loss: bool = false  # stops multiple loss triggers

# Each stage has its own steps
var stages = {
	"stage_1": [
		{
			"correct_choice": "choice_hobbyist store",
			"retry_label": "stage1_step1",
			"step_index": 0  # Track which step this is
		},
	
	],

	"stage_2": [
		{
			"correct_choice": "choice_1_kevin",
			"retry_label": "stage2_step1",
			"step_index": 0

		}
	],

	"stage_3": [
		{
			"correct_choice": "what_loud",
			"retry_label": "what_happened",
			"step_index": 0

		},
		{
			"correct_choice": "evidence1_noisemaker",
			"retry_label": "evidence_1",
			"step_index": 1

		},
		{
			"correct_choice": "who_iris",
			"retry_label": "who_felt",
			"step_index": 2
	
		},
		{
			"correct_choice": "noisemaker_counter",
			"retry_label": "where_noisemaker",
			"step_index": 3
		},
		{
			"correct_choice": "purpose_deafen",
			"retry_label": "purpose_noisemaker",
			"step_index": 4
		},
		{
			"correct_choice": "place_supply",
			"retry_label": "place",
			"step_index": 5
		},
		{
			"correct_choice": "blackout_surge",
			"retry_label": "cause_blackout",
			"step_index": 6
		},
		{
			"correct_choice": "evidence2_battery",
			"retry_label": "evidence_2",
			"step_index": 7

		},
		
		{
			"correct_choice": "evidence3_crumpled",
			"retry_label": "evidence_3",
			"step_index": 8

		},
		
		{
			"correct_choice": "move_touch",
			"retry_label": "arrows_drawing",
			"step_index": 9

		},
	]
}


func _ready():
	current_lives = max_lives
	
	if not Dialogic.signal_event.is_connected(_on_choice_made):
		Dialogic.signal_event.connect(_on_choice_made)
	start("stage_3")
	

# start a stage
func start(stage_name: String):
	current_stage = stage_name
	current_step_index = 0
	current_lives = max_lives #on new stage make it max lives
	
	# Start the timeline
	Dialogic.start(stage_name)


# Helper function to find step index from retry label
func get_step_index_from_retry_label(stage: String, retry_label: String) -> int:
	var stage_steps = stages.get(stage, [])
	for step in stage_steps:
		if step.get("retry_label", "") == retry_label:
			return step.get("step_index", 0)
	return 0


func _on_choice_made(choice_id: String):
	
	print("\n--- SIGNAL RECEIVED ---")
	print("Choice ID: ", choice_id)
	print("Stage: ", current_stage)
	print("Step Index: ", current_step_index)
	print("Lives: ", current_lives)
	
	
	#bad practice ik cuz these arent even choices but i needed this working. 
	#this stuff is just checking for end signals:
	
	if choice_id.ends_with("_complete"):
		if choice_id == "stage_1_complete":
			start("stage_2")
		if choice_id == "stage_2_complete":
			start("stage_3")
		if choice_id == "stage_3_complete":
			_win()
		return #don't treat this signal as wrong
			
	
	if current_stage == "":
		return
	
	# Make sure step index is valid
	if current_step_index >= stages[current_stage].size():
		print("ERROR: Step index out of bounds!")
		return
	
	var step = stages[current_stage][current_step_index]
	var correct_choice = step["correct_choice"]

	if choice_id == correct_choice:
		_correct_step()
	else:
		_wrong_step()



func _correct_step():
	print("✅ CORRECT")
	current_step_index += 1
	
	print("New Step Index: ", current_step_index)
	
	# Optional: Check if stage is complete
	if current_step_index >= stages[current_stage].size():
		print("Stage ", current_stage, " complete!")
		# You might want to emit a signal or call a function here


func _wrong_step():
	if handling_wrong_step or handling_loss:
		return
	
	handling_wrong_step = true
	
	print("❌ WRONG")
	current_lives -= 1
	
	print("Lives remaining: ", current_lives)
	
	# Get the current step info before any changes
	var step = stages[current_stage][current_step_index]
	var retry_label = step.get("retry_label", "")
	
	if current_lives <= 0:
		# We lost! Handle loss reaction
		handling_wrong_step = false
		_handle_loss(retry_label)
		return
	
	if retry_label != "":
		# Play the mistake timeline first
		if mistake_timeline != "":
			# Connect to the timeline ended signal
			if not Dialogic.timeline_ended.is_connected(_on_mistake_timeline_ended):
				Dialogic.timeline_ended.connect(_on_mistake_timeline_ended)
			
			# Store the target for later
			pending_retry_stage = current_stage
			pending_retry_label = retry_label
			
			# Start the mistake timeline
			Dialogic.start(mistake_timeline)
			# DON'T reset handling_wrong_step yet! Wait for the timeline to finish
			return  # Important: exit here, don't reset handling_wrong_step
		else:
			# No mistake timeline, just restart directly (but keep the same lives!)
			_reset_to_retry_label_no_lives_reset(current_stage, retry_label)
	
	# Only reset if we didn't play a mistake timeline
	handling_wrong_step = false


func _handle_loss(retry_label: String):
	if handling_loss:
		return
	
	handling_loss = true
	
	print("💀 LOSS - Out of lives!")
	total_losses += 1
	
	if loss_timeline != "":
		# Connect to the timeline ended signal if not already
		if not Dialogic.timeline_ended.is_connected(_on_loss_timeline_ended):
			Dialogic.timeline_ended.connect(_on_loss_timeline_ended)
		
		# Store where to resume
		pending_loss_stage = current_stage
		pending_loss_label = retry_label
		
		# Reset lives for the loss (since they're at 0)
		current_lives = max_lives
		
		# Play the loss timeline
		Dialogic.start(loss_timeline)
	else:
		# No loss timeline, just restart directly with fresh lives
		_reset_to_retry_label_with_lives_reset(current_stage, retry_label)
		handling_loss = false


# For regular mistakes - DON'T reset lives
func _reset_to_retry_label_no_lives_reset(stage: String, retry_label: String):
	# Find the correct step index for this retry label
	var new_step_index = get_step_index_from_retry_label(stage, retry_label)
	current_step_index = new_step_index
	# IMPORTANT: Do NOT reset lives here!
	Dialogic.start(stage, retry_label)


# For loss - reset lives
func _reset_to_retry_label_with_lives_reset(stage: String, retry_label: String):
	# Find the correct step index for this retry label
	var new_step_index = get_step_index_from_retry_label(stage, retry_label)
	current_step_index = new_step_index
	current_lives = max_lives
	Dialogic.start(stage, retry_label)


# variables to store where to resume after mistake timeline
var pending_retry_stage: String = ""
var pending_retry_label: String = ""

# variables to store where to resume after loss timeline
var pending_loss_stage: String = ""
var pending_loss_label: String = ""


func _on_mistake_timeline_ended():
	# When the mistake timeline finishes, resume the actual stage
	if pending_retry_stage != "" and pending_retry_label != "":
		_reset_to_retry_label_no_lives_reset(pending_retry_stage, pending_retry_label)
		pending_retry_stage = ""
		pending_retry_label = ""
	
	# Now it's safe to allow new wrong choices
	handling_wrong_step = false


func _on_loss_timeline_ended():
	# When the loss timeline finishes, restart the player at the retry label
	if pending_loss_stage != "" and pending_loss_label != "":
		_reset_to_retry_label_with_lives_reset(pending_loss_stage, pending_loss_label)
		pending_loss_stage = ""
		pending_loss_label = ""
	
	# Now it's safe to allow new wrong choices
	handling_loss = false


func _win():
	print("Minigame WIN")
	# You can add win logic here - maybe close the minigame, award points, etc.


func _lose():
	# This is now handled by _handle_loss, but keep for compatibility if needed
	print("Minigame LOSE")
	total_losses += 1
	current_step_index = 0
	current_lives = max_lives
	Dialogic.start(current_stage)
