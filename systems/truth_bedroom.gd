@tool
extends GameScene

const TALK_TO_FRIENDS = preload("uid://7uhydbqesnaf")
const FIND_MONSTERS = preload("uid://d4dkqbn5okf0t")

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if Global.game_controller == null:
		print("game_controller is null")
		return
	
	match Global.game_controller.game_state:
		GameController.GameState.GAME_BEGIN:
			QuestManager.start_quest(TALK_TO_FRIENDS)
			Global.game_controller.game_state = GameController.GameState.STARTED
		GameController.GameState.POST_MINIGAME:
			QuestManager.start_quest(FIND_MONSTERS)
			Global.game_controller.game_state = GameController.GameState.MONSTERS
