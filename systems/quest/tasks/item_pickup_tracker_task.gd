class_name ItemPickupTrackerTask
extends Task

@export var item_ids: Array[String]

func init():
	EventBus.ItemPickup.connect(_on_item_pickup)


func _on_item_pickup(item: Item):
	for item_id in item_ids:
		if item.item_id == item_id:
			item_ids.erase(item_id)
			advance()
			break
