@tool
extends GameScene

const EXAMPLE_QUEST = preload("uid://7uhydbqesnaf")

func _ready() -> void:
	var game_state = Global.game_controller.game_state
	match game_state.get("progression"):
		"game_begin":
			QuestManager.start_quest(EXAMPLE_QUEST)
			game_state.set("progression", "started")
