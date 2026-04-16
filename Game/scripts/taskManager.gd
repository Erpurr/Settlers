extends Node

signal task_added(task: Task)

var _queue: Array[Task] = []

func post_task(task: Task) -> void:
	_queue.append(task)
	emit_signal("task_added", task)
	print("Task posted:", Task.Type.keys()[task.type])

func request_task() -> Task:
	if _queue.is_empty():
		return null	
	return _queue.pop_front()

func has_tasks() -> bool:
	return not _queue.is_empty()

func get_queue_size() -> int:
	return _queue.size()
	
# -------- Meira? ---------
