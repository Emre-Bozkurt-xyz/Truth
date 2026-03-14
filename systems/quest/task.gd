@abstract
class_name Task
extends Resource

# Forwards these events to owner quest to globally publish it
signal completed(task: Task)
signal advanced(task: Task)

@export var task_id: String
@export var task_description: String
var is_complete: bool

@export var steps: int = 1
var progress: int = 0

@abstract 
func init()

func advance():
	if is_complete: return
	
	progress += 1
	advanced.emit(self)
	if progress == steps:
		is_complete = true
		completed.emit(self)
