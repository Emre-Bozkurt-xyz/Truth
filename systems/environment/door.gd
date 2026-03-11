class_name Door
extends Node2D

@export var door_name: String = ""
@export var to_scene: PackedScene

var proximity_target: ProximityTarget
var selected: bool = false
var waiting: bool = false

func _ready() -> void:
	Dialogic.signal_event.connect(_on_choice_made)
	
	proximity_target = find_child("ProximityTarget")
	if not proximity_target:
		push_warning("No proximity target found for door: ", door_name)
		return
	
	proximity_target.interacted.connect(_on_interacted)
	proximity_target.selection_changed.connect(_on_selection_changed)

func _on_selection_changed(state: bool):
	selected = state
	print("Selection changed: ", state)

func _on_interacted() -> void:
	if waiting: return
	
	Dialogic.VAR.door_name = door_name
	Dialogic.start('door_dialogue')
	waiting = true

func _on_choice_made(arg: String):
	if not selected: return
	
	match arg:
		"door_accept":
			#TODO: Switch scene
			print("tryna switch scene")
			waiting = false
		"door_decline":
			waiting = false
