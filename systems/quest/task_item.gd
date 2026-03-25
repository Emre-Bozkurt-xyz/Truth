class_name TaskItem
extends Panel

@onready var step_description: Label = %StepDescription
@onready var step_progress: Label = %StepProgress

func init(task: Task):
	step_description.text = task.task_description

func complete(task: Task):
	pass

func advance(task: Task):
	step_progress.text = str(task.progress) + "/" + str(task.steps)
