@tool
class_name ProximityDialogueDoor
extends Door

@export var description: String
@export var indicator: Sprite2D

@onready var proximity_target: ProximityTarget = $ProximityTarget

var selected: bool = false
var waiting: bool = false

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	
	Dialogic.signal_event.connect(_on_choice_made)
	
	if indicator != null:
		indicator.visible = false

	if not proximity_target:
		push_warning("No proximity target found for door: ", description)
		return
	
	proximity_target.interacted.connect(_on_interacted)
	proximity_target.selection_changed.connect(_on_selection_changed)

func _on_selection_changed(state: bool):
	selected = state
	if indicator == null: return
	
	if selected:
		indicator.visible = true
	else:
		indicator.visible = false

func _on_interacted() -> void:
	if waiting: return
	
	Dialogic.VAR.door_name = description
	Dialogic.start('door_dialogue')
	waiting = true

func _on_choice_made(arg: String):
	if not selected: return
	
	match arg:
		"door_accept":
			enter()
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
