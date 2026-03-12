@tool
class_name GameScene
extends Node2D

@export var door_container: Node:
	set(val):
		door_container = val
		update_configuration_warnings()
@export var floor_marker: Node2D:
	set(val):
		floor_marker = val
		update_configuration_warnings()

func get_door(door_id: String) -> Door:
	for door in door_container.get_children():
		if door is Door and (door as Door).id == door_id:
			return door
	
	return null


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if door_container == null:
		warnings.append("Door container required.")
	if floor_marker == null:
		warnings.append("Floor marker required.")
	return warnings
