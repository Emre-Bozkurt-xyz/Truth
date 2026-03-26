extends Node

var active_quests: Array[Quest]

func _ready() -> void:
	EventBus.QuestComplete.connect(_on_quest_complete)


func _on_quest_complete(quest: Quest):
	active_quests.erase(quest)
	if quest.next_quest != null:
		start_quest(quest.next_quest)


func start_quest(quest: Quest):
	active_quests.append(quest)
	quest.init()
