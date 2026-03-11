extends Control

@onready var fps: Label = $FPS

@onready var fps_timer: Timer = $FPSTimer

func _ready() -> void:
	fps_timer.timeout.connect(update_fps)
	
func update_fps():
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
