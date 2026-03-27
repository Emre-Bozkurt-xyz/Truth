class_name DialogicSignalTrackerTask
extends Task

@export var signal_name: String

func init():
	Dialogic.signal_event.connect(_on_signal)


func _on_signal(arg: String):
	if arg == signal_name:
		advance()
