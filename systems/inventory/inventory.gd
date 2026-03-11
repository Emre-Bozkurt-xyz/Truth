# Global script - Inventory
extends Node

var inventory: Dictionary[String, Item]

func consume(item_name: String) -> bool:
	if not inventory[item_name]: return false
	
	inventory[item_name].stack -= 1
	if inventory[item_name].stack <= 0:
		inventory[item_name] = null
	
	return true

func has(item_name: String) -> bool:
	return inventory[item_name] and inventory[item_name].stack > 0
