class_name GameController
extends Node

@onready var loading_screen: Control = %LoadingScreen

const PLAYER = preload("uid://dphh13vg15hgj")

var current_scene: Node
var scene_cache: Dictionary[String, PackedScene]
var game_state: Dictionary = {}

func _ready() -> void:
	Global.game_controller = self
	game_state.set("progression", "game_begin")
	game_state.set("lock_on_dialogue", true)
	change_scene("res://scenes/truth_bedroom.tscn", "bed")
	
	Dialogic.timeline_started.connect(_on_dialogue_start)
	Dialogic.timeline_ended.connect(_on_dialogue_end)
	EventBus.DoorEntered.connect(_on_door_entered)


func change_scene(scene_path: String, door_id: String = "") -> void:
	loading_screen.enter()
	
	var packed: PackedScene
	if scene_path.find("res://") == -1:
		print("brah")
		scene_path = "res://scenes/" + scene_path + ".tscn"
	
	if scene_cache.has(scene_path):
		packed = scene_cache[scene_path]
	else:
		packed = load(scene_path)
		scene_cache[scene_path] = packed
	
	var new_scene = packed.instantiate()
	
	# Wait for loading screen to go black
	await loading_screen.entered
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
	
	var cam: Camera2D = player.get_node("Camera2D")
	if current_scene is GameScene:
		# Game scene specific stuff
		
		if cam != null:
			if current_scene.left_cam_limit != null:
				cam.limit_left = current_scene.left_cam_limit.global_position.x
			if current_scene.right_cam_limit != null:
				cam.limit_right = current_scene.right_cam_limit.global_position.x
			if current_scene.top_cam_limit != null:
				cam.limit_top = current_scene.top_cam_limit.global_position.y
			if current_scene.bottom_cam_limit != null:
				cam.limit_bottom = current_scene.bottom_cam_limit.global_position.y
		
	current_scene.add_child(player)


func _on_door_entered(door: Door):
	if door.to_scene == null:
		return
	
	change_scene(door.to_scene, door.to_door_id)


func _on_dialogue_start():
	if (Global.player == null) \
		or (not game_state.get("lock_on_dialogue")): return
	
	Global.player.locked = true


func _on_dialogue_end():
	if (Global.player == null) \
		or (not game_state.get("lock_on_dialogue")): return
	
	Global.player.locked = false
