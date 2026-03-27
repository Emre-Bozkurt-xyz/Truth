@tool
extends GameScene


func _ready() -> void:
	if Global.game_controller.game_state == GameController.GameState.MINIGAME:
		Global.game_controller.start_minigame()
