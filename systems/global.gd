extends Node



var player: Player
var game_controller: GameController

func is_curr_state_past(_state: GameController.GameState) -> bool:
	if _state == null: return true
	return _state <= game_controller.game_state
