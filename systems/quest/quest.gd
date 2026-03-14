class_name Quest
extends Resource

@export var quest_name: String

@export var tasks: Array[Task]

var is_complete: bool = false

func init():
	for task in tasks:
		task.init()
		task.advanced.connect(_on_task_advanced)
		task.completed.connect(_on_task_completed)
	
	EventBus.QuestStart.emit(self)


func all_tasks_complete() -> bool:
	for task in tasks:
		if not task.is_complete:
			return false
	return true


func _on_task_advanced(task: Task):
	EventBus.TaskAdvance.emit(self, task)


func _on_task_completed(task: Task):
	if is_complete: return
	
	EventBus.TaskComplete.emit(self, task)
	if all_tasks_complete():
		is_complete = true
		EventBus.QuestComplete.emit(self)
