class_name QuestPanel
extends Control

const QUEST_ITEM = preload("uid://brqxxf0m7iym8")

@onready var quest_container: VBoxContainer = %QuestContainer

var quest_items: Dictionary[Quest, QuestItem]

func _ready() -> void:
	EventBus.QuestStart.connect(_on_quest_started)
	EventBus.QuestComplete.connect(_on_quest_completed)


func _on_quest_started(quest: Quest):
	var quest_item: QuestItem = QUEST_ITEM.instantiate()
	quest_container.add_child(quest_item)
	quest_item.init(quest)
	quest_items[quest] = quest_item


func _on_quest_completed(quest: Quest):
	quest_items[quest].queue_free()
	quest_items.erase(quest)
