class_name Notification
extends Label

const TRANSPARENT: Color = Color(1.0, 1.0, 1.0, 0.0)
const FILLED: Color = Color(1.0, 1.0, 1.0, 1.0)
const OFFSET: Vector2 = Vector2(0, 10)

var display_text: String = ""
var alive_time: float = 1.0

func _init(_display_text: String, _alive_time: float = 1.0) -> void:
	display_text = _display_text
	alive_time = _alive_time

func _ready() -> void:
	modulate = TRANSPARENT
	text = display_text
	
	# wait for vboxcontainer to position this jit
	await get_tree().process_frame
	
	# then do a lil anim
	var original_pos = position
	position = original_pos + OFFSET
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", FILLED, 0.2)
	tween.parallel().tween_property(self, "position", original_pos, 0.2)
	await get_tree().create_timer(alive_time).timeout
	tween.stop()
	# dont question why i am making a new one
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", TRANSPARENT, 0.2)
	tween.parallel().tween_property(self, "position", original_pos - OFFSET, 0.2)
	await tween.finished
	# KILL
	queue_free()
