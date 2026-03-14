@tool
@abstract
class_name Door
extends Node2D

var cfg_warnings = []

@export var id: String = ""
@export var to_door_id: String = ""
@export var to_scene: PackedScene:
	set(val):
		to_scene = val
		update_configuration_warnings()
@export var player_spawn: Node2D:
	set(val):
		player_spawn = val
		update_configuration_warnings()


func _ready() -> void:
	child_entered_tree.connect(_on_children_changed)
	child_exiting_tree.connect(_on_children_changed)


func enter():
	EventBus.DoorEntered.emit(self)


func _on_children_changed(_node = null) -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:	
	if player_spawn == null:
		cfg_warnings.append("Player spawn missing.")
	
	if to_scene == null:
		cfg_warnings.append("To Scene is missing.")
	
	var warnings = cfg_warnings.duplicate()
	cfg_warnings.clear()
	return warnings
