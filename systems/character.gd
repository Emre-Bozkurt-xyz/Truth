class_name Character
extends Sprite2D

@export var character_id: String
@export var spawn_during: GameController.GameState
@export var look_at_player: bool = false
@export var indicator_look_at_player: bool = false
@export var player_snap: Node2D
@export var auto_interact: bool = false
@export var one_shot_dialogue: bool = true
@export var hide_on_timeline_finish: bool = false
@export var dialogue_name: String
@export var dialogue_label: String
@export var proximity_target: ProximityTarget
@export var indicator: Indicator

var selected: bool
var waiting: bool
var player_found: bool = false
var initial_indicator_pos: Vector2

func _ready() -> void:
	if Global.game_controller.game_state != spawn_during:
		queue_free()
		return
	visible = true
	
	var state = Global.character_dialogue_state.get(character_id)
	if state != null and proximity_target != null and state and one_shot_dialogue:
		proximity_target.interactable = false
	else:
		Global.character_dialogue_state[character_id] = false
	
	Dialogic.timeline_ended.connect(_on_dialogue_finish)
	
	if proximity_target != null:
		proximity_target.selection_changed.connect(_on_selection_changed)
		proximity_target.interacted.connect(_on_interacted)
		if auto_interact:
			proximity_target.interaction_priority = 10
	
	while not player_found:
		if Global.player != null:
			player_found = true
			if indicator != null: initial_indicator_pos = indicator.position
		
		await get_tree().process_frame


func _physics_process(_delta: float) -> void:
	if not player_found: return
	
	var dir: Vector2 = global_position.direction_to(Global.player.global_position)
	var facing_right: bool = dir.x < 0.0
	
	if look_at_player:
		if facing_right:
			flip_h = true
		else:
			flip_h = false
	if indicator_look_at_player and indicator != null:
		if facing_right:
			indicator.position.x = initial_indicator_pos.x
		else:
			indicator.position.x = initial_indicator_pos.x * -1.0


func _on_interacted():
	if waiting: return
	if dialogue_name == "": return
	if Global.character_dialogue_state.get(character_id) and one_shot_dialogue:
		return
	
	Global.character_dialogue_state.set(character_id, true)
	if one_shot_dialogue and proximity_target != null and indicator != null:
		proximity_target.interactable = false
		indicator.visible = false
	
	if player_snap != null:
		Global.game_controller.move_player(player_snap.global_position)
	
	Dialogic.start(dialogue_name, dialogue_label)
	waiting = true


func _on_selection_changed(state: bool):
	selected = state
	if state and auto_interact:
		await get_tree().physics_frame
		await get_tree().create_timer(0.5).timeout
		await get_tree().process_frame
		_on_interacted()
	if indicator == null: return
	
	indicator.toggle(selected)


func _on_dialogue_finish():
	if waiting and hide_on_timeline_finish:
		queue_free()
		
	waiting = false
