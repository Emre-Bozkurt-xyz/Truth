class_name Item
extends Resource

@export var item_id: String
@export var item_name: String
@export var icon: Texture2D
@export var description: String
@export var pickup_timeline: String = ""
@export var stack_size: int = 1:
	set(val):
		stack_size = min(val, 1)

var stack: int = 0
