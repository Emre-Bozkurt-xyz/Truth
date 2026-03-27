class_name QuestItem
extends Panel

const TASK_ITEM = preload("uid://bpoh14u3jgi8t")
const QUEST_FONT = preload("res://assets/Nanya-j9Rjl.otf")

@onready var quest_name: Label = %QuestName
@onready var task_container: VBoxContainer = %TaskContainer

var my_quest: Quest
var tasks: Dictionary[Task, TaskItem]

func _ready() -> void:
	EventBus.TaskAdvance.connect(_on_task_advanced)
	EventBus.TaskComplete.connect(_on_task_compeleted)


func init(quest: Quest):
	my_quest = quest
	quest_name.text = quest.display_name
	quest_name.add_theme_font_override("font", QUEST_FONT)
	quest_name.add_theme_font_size_override("font_size", 24)
	for task in quest.tasks:
		var task_item: TaskItem = TASK_ITEM.instantiate()
		task_container.add_child(task_item)
		task_item.init(task)
		tasks[task] = task_item


func _on_task_advanced(quest: Quest, task: Task):
	if quest != my_quest: return
	tasks[task].advance(task)


func _on_task_compeleted(quest: Quest, task: Task):
	if quest != my_quest: return
	tasks[task].complete(task)
