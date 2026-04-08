extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		ResourceManager.add("wood", 10)
		print("Wood: ", ResourceManager.get_amount("wood"))
	if event.is_action_pressed("ui_select"):
		var success := ResourceManager.spend("wood", 25)
		print("Spent wood: ",success)
		
