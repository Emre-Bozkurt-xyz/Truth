class_name GameScene
extends Node2D

@export var door_container: Node
@export var floor_marker: Node2D

func get_door(door_id: String) -> Door:
	for door in door_container.get_children():
		if door is Door and (door as Door).id == door_id:
			return door
	
	return null
