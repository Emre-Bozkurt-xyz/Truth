class_name Interactor
extends Node2D

@onready var proximity_sensor: ProximitySensor = $ProximitySensor

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if proximity_sensor.curr_selected: 
			proximity_sensor.curr_selected.interact()
