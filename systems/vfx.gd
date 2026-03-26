class_name VFX
extends Sprite2D

@export var spawn_during: Array[GameController.GameState]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var matches = false
	for state in spawn_during:
		if Global.game_controller.game_state == state:
			matches = true 
			break
	
	if !matches:
		queue_free()
