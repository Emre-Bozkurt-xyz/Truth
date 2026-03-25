class_name Indicator
extends Sprite2D

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
var state: bool = false

func _ready() -> void:
	visible = false


func toggle(_state: bool = not state):
	state = _state
	visible = state
	if state:
		audio_player.play()
