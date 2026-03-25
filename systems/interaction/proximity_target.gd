class_name ProximityTarget
extends Area2D

signal selection_changed(val: bool)
signal interacted()

@export var interactable_after: GameController.GameState = GameController.GameState.GAME_BEGIN

var selected: bool = false:
	get: 
		return selected
	set(val):
		selection_changed.emit(val)
		selected = val


func interact() -> void:
	interacted.emit()
