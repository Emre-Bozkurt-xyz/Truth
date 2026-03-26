extends Sprite2D

@export var spawn_during: GameController.GameState
@export var dialogue_name: String
@export var dialogue_label: String
@export var proximity_target: ProximityTarget
@export var indicator: Indicator

var selected: bool
var waiting: bool

func _ready() -> void:
	if Global.game_controller.game_state != spawn_during:
		queue_free()
		return
	
	Dialogic.timeline_ended.connect(_on_dialogue_finish)
	
	proximity_target.selection_changed.connect(_on_selection_changed)
	proximity_target.interacted.connect(_on_interacted)


func _on_interacted():
	if waiting: return
	if dialogue_name == "": return
	
	Dialogic.start(dialogue_name, dialogue_label)
	waiting = true


func _on_selection_changed(state: bool):
	selected = state
	if indicator == null: return
	
	indicator.toggle(selected)


func _on_dialogue_finish():
	waiting = false
