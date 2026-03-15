extends Control

@onready var notification_container: VBoxContainer = %NotificationContainer

func _ready() -> void:
	EventBus.ItemPickup.connect(_on_item_pickup)


func _on_item_pickup(item: Item):
	var text = "+ " + item.item_name
	var notif := Notification.new(text, 2.0)
	
	notification_container.add_child(notif)
