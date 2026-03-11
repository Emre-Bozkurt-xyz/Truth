class_name GameController
extends Node

const PLAYER = preload("uid://dphh13vg15hgj")

var current_scene: GameScene
var scene_cache: Dictionary[String, PackedScene]
var game_state: Dictionary = {}

func _ready() -> void:
	change_scene("res://scenes/intro.tscn", "door1")


func change_scene(scene_path: String, door_id: String) -> void:
	var packed: PackedScene
	
	if scene_cache.has(scene_path):
		packed = scene_cache[scene_path]
	else:
		packed = load(scene_path)
		scene_cache[scene_path] = packed
	
	var new_scene = packed.instantiate()
	
	if not (new_scene is GameScene):
		push_warning("Scene: " + scene_path + " is not valid scene of GameScene type.")
		return
	
	if current_scene:
		current_scene.queue_free()
	
	add_child(new_scene)
	current_scene = new_scene
	
	spawn_player(door_id)


func spawn_player(door_id: String):
	var player: Player = PLAYER.instantiate()
	
	player.global_position.x = current_scene.get_door(door_id).player_spawn.global_position.x
	player.global_position.y = current_scene.floor_marker.global_position.y
	
	current_scene.add_child(player)
