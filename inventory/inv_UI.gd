extends Control

@onready var description_panel: Panel = %DescriptionPanel
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_container: GridContainer = %ItemContainer
@onready var slots = item_container.get_children()


var slots_dict: Dictionary[Item, ItemSlot]
var isOpen = false

func _ready():
	close()
	description_panel.visible = false
	for slot in slots:
		if slot is ItemSlot:
			slot.pressed.connect(func(): _on_slot_pressed(slot))
	EventBus.ItemPickup.connect(_on_item_pickup)
	EventBus.ItemUsed.connect(_on_item_used)


func _on_slot_pressed(slot: ItemSlot):
	description_panel.visible = true
	item_name.text = slot.my_item.item_name
	item_description.text = slot.my_item.description


func _on_item_pickup(item: Item):
	var pos: int = -1
	for i in range(slots.size() - 1):
		if !slots[i].full():
			pos = i
			break
	
	if pos == -1: return
	
	slots[pos].take(item)
	slots_dict[item] = slots[pos]


func _on_item_used(item: Item):
	slots_dict[item].drop()
	slots_dict[item] = null
	clear_description_panel()


func _process(_delta) -> void:
	if not Inventory.ui_enabled:
		if isOpen:
			if Global.player != null:
				Global.player.locked = false
			close()
		return
	
	if Input.is_action_just_pressed("toggle_inventory"):
		if isOpen:
			Global.player.locked = false
			close()
		else:
			Global.player.locked = true
			open()


func open():
	if not Inventory.ui_enabled: return
	visible = true
	isOpen = true


func close():
	visible = false
	isOpen = false
	clear_description_panel()


func clear_description_panel():
	description_panel.visible = false
	item_name.text = ""
	item_description.text = ""
