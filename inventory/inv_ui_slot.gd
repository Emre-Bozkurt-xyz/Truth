class_name ItemSlot
extends Button

var my_item: Item
@onready var item_visual: TextureRect = %Icon

func _ready() -> void:
	disabled = true


func take(item: Item):
	item_visual.visible = true
	item_visual.texture = item.icon
	my_item = item
	disabled = false


func drop():
	my_item = null
	item_visual.visible = false
	disabled = true


func full() -> bool:
	return my_item != null
