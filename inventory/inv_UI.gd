extends Control

@onready var inv: Inv = preload("res://inventory/playerInv.tres")
@onready var slots: Array = $InvSlots/GridContainer.get_children()

var isOpen = false
@onready var player = get_parent()

func _ready():
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
	
func _process(delta):
	if Input.is_action_just_pressed("tab"):
		if isOpen:
			player.locked = false
			close()
		else:
			player.locked = true
			open()
func open():
	visible = true
	isOpen = true
func close():
	visible = false
	isOpen = false
