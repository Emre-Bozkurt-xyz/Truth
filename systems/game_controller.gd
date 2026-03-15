class_name GameController
extends Node

@onready var loading_screen: Control = $LoadingScreen

const PLAYER = preload("uid://dphh13vg15hgj")

var current_scene: Node
var scene_cache: Dictionary[String, PackedScene]
var game_state: Dictionary = {}

func _ready() -> void:
	Global.game_controller = self
	change_scene("res://scenes/intro.tscn", "door1")
	
	EventBus.DoorEntered.connect(_on_door_entered)


func change_scene(scene_path: String, door_id: String = "") -> void:
	loading_screen.enter()
	
	var packed: PackedScene
	
	if scene_cache.has(scene_path):
		packed = scene_cache[scene_path]
	else:
		packed = load(scene_path)
		scene_cache[scene_path] = packed
	
	var new_scene = packed.instantiate()
	
	if current_scene:
		current_scene.queue_free()
	
	add_child(new_scene)
	current_scene = new_scene
	
	if new_scene is GameScene:
		spawn_player(door_id)
	
	loading_screen.exit()


func spawn_player(door_id: String):
	if door_id == "":
		push_warning("No door id passed in when switching into GameScene.")
		return
	
	var door: Door = current_scene.get_door(door_id)
	if door == null:
		push_warning("Door " + door_id + " could not be found in scene.")
		return
		
	var player: Player = PLAYER.instantiate()
	player.global_position.x = door.player_spawn.global_position.x
	player.global_position.y = current_scene.floor_marker.global_position.y
	
	current_scene.add_child(player)


func _on_door_entered(door: Door):
	if door.to_scene == null:
		return
	
	change_scene(door.to_scene.resource_path, door.to_door_id)
