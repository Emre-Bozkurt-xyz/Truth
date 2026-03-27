extends Node2D

@onready var cry_player: AudioStreamPlayer = $CryPlayer

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	cry_player.play()
	
	await get_tree().create_timer(3.0).timeout
	Dialogic.start("crying_sleeping")
	
	await Dialogic.timeline_ended
	Global.game_controller.game_state = GameController.GameState.MONSTERS
	Global.game_controller.change_scene("truth_bedroom", "bed")
