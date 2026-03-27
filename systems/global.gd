extends Node

const COLLECT_EVIDENCE = preload("uid://di7xn3q17smp6")

var player: Player
var game_controller: GameController

var world_item_state: Dictionary[String, bool]
var character_dialogue_state: Dictionary[String, bool]

func is_curr_state_past(_state: GameController.GameState) -> bool:
	if _state == null: return true
	return _state <= game_controller.game_state


func start_evidence_collection():
	QuestManager.start_quest(COLLECT_EVIDENCE)
	game_controller.game_state = game_controller.GameState.COLLECTING
	pass


func switch_to_conclusion():
	game_controller.current_scene.get_node("KevinGone").queue_free()
	game_controller.game_state = GameController.GameState.CONCLUSION
