class_name RoomEnterTrackerTask
extends Task

@export var room_name: String

func init():
	var curr_scene = Global.game_controller.current_scene
	if curr_scene is GameScene:
		if curr_scene.room_name == room_name:
			advance()
			return
	
	EventBus.RoomEntered.connect(_on_room_enter)


func _on_room_enter(_room_name: String):
	if room_name == _room_name:
		advance()
