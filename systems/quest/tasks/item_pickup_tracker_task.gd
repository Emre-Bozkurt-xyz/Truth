class_name ItemPickupTrackerTask
extends Task

@export var item_id: String

func init():
	EventBus.ItemPickup.connect(_on_item_pickup)


func _on_item_pickup(item: Item):
	if item.item_id == item_id:
		advance()
