@tool
class_name ProximityDialogueDoor
extends Door

@export var door_name: String

# Temp
@onready var sprite_2d: Sprite2D = $Sprite2D

var proximity_target: ProximityTarget
var selected: bool = false
var waiting: bool = false

func _ready() -> void:
	super()
	Dialogic.signal_event.connect(_on_choice_made)
	
	proximity_target = find_child("ProximityTarget")
	if not proximity_target:
		push_warning("No proximity target found for door: ", door_name)
		return
	
	proximity_target.interacted.connect(_on_interacted)
	proximity_target.selection_changed.connect(_on_selection_changed)

func _on_selection_changed(state: bool):
	selected = state
	if state:
		sprite_2d.modulate = Color(0.5, 0.5, 0.5)
	else:
		sprite_2d.modulate = Color(255, 255, 255)

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


func _get_configuration_warnings() -> PackedStringArray:
	var proximity_target_found: bool = false
	for child in get_children():
		if child is ProximityTarget:
			proximity_target_found = true
	if not proximity_target_found:
		cfg_warnings.append("Missing ProximityTarget child.")

	return super()
