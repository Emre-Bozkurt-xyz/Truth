@tool
extends GameScene

const EXAMPLE_QUEST = preload("uid://7uhydbqesnaf")

func _ready() -> void:
	if Global.game_controller == null:
		print("game_controller is null")
		return
	
	match Global.game_controller.game_state:
		GameController.GameState.GAME_BEGIN:
			QuestManager.start_quest(EXAMPLE_QUEST)
			Global.game_controller.game_state = GameController.GameState.STARTED
