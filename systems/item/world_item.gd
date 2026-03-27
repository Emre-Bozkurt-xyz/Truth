@tool
class_name WorldItem
extends Node2D

@export var world_item_id: String
@export var item: Item
@export var indicator: Sprite2D

@onready var proximity_target: ProximityTarget = $ProximityTarget
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var selected: bool = false
var waiting: bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	var state = Global.world_item_state.get(world_item_id)
	if state != null and state:
		queue_free()
		return
	else:
		Global.world_item_state[world_item_id] = false
	
	child_entered_tree.connect(_on_children_changed)
	child_exiting_tree.connect(_on_children_changed)
	
	Dialogic.signal_event.connect(_on_choice_made)
	
	if not proximity_target:
		push_warning("No proximity target found for world item: " + name)
		return
	proximity_target.interacted.connect(_on_interacted)
	proximity_target.selection_changed.connect(_on_selection_changed)


func _on_interacted() -> void:
	if waiting: return
	
	Dialogic.VAR.item_name = item.item_name
	Dialogic.VAR.item_description = item.description
	Dialogic.start('item_pickup_dialogue')
	waiting = true


func _on_selection_changed(state: bool):	
	selected = state
	if indicator == null: return
	
	indicator.toggle(selected)


func _on_choice_made(arg: String):
	if not selected: return
	
	match arg:
		"item_pickup_accept":
			audio_player.play()
			Inventory.obtain(item)
			Global.world_item_state.set(world_item_id, true)
			
			
			Dialogic.start(item.item_id)
				
			queue_free()
		"item_pickup_decline":
			waiting = false


func _on_children_changed(_node = null) -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var cfg_warnings = []
	var proximity_target_found: bool = false
	for child in get_children():
		if child is ProximityTarget:
			proximity_target_found = true
	if not proximity_target_found:
		cfg_warnings.append("Missing ProximityTarget child.")

	return cfg_warnings
