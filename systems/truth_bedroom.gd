@tool
extends GameScene

const TALK_TO_FRIENDS = preload("uid://7uhydbqesnaf")

func _ready() -> void:
	if Global.game_controller == null:
		print("game_controller is null")
		return
	
	match Global.game_controller.game_state:
		GameController.GameState.GAME_BEGIN:
			QuestManager.start_quest(TALK_TO_FRIENDS)
			Global.game_controller.game_state = GameController.GameState.STARTED
