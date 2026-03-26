# Global script - Inventory
extends Node

var inventory: Dictionary[String, Item]
var ui_enabled: bool = true

func obtain(item: Item):
	inventory[item.item_name] = item
	EventBus.ItemPickup.emit(item)


func use(item_name: String) -> bool:
	if not inventory[item_name]: return false
	
	inventory[item_name].stack -= 1
	EventBus.ItemUsed.emit(inventory[item_name])
	if inventory[item_name].stack <= 0:
		inventory[item_name] = null
	
	return true


func has(item_name: String) -> bool:
	return inventory[item_name] and inventory[item_name].stack > 0
