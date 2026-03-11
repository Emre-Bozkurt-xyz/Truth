class_name ProximitySensor
extends Area2D

var proximity_targets: Array[Area2D]
var curr_selected: ProximityTarget

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	proximity_targets.append(area)
	update_selected_target()

func _on_area_exited(area: Area2D):
	proximity_targets.erase(area)
	update_selected_target()

func update_selected_target():
	var nearest = null
	var nearest_dist: float = INF
	for target in proximity_targets:
		if target is ProximityTarget:
			var dist: float = global_position.distance_to(target.global_position)
			if absf(dist) < nearest_dist:
				nearest_dist = absf(dist)
				nearest = target
	
	if nearest == null or curr_selected == nearest: return
	if curr_selected: curr_selected.selected = false
	nearest.selected = true
	curr_selected = nearest
