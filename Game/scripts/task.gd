extends Node

class_name Task

enum Type {
	GATHER_WOOD,
	GATHER_STONE,
	GATHER_FOOD,
	DELIVER,
	BUILD
}

var type: Type
var target_position: Vector3
var target_node: Node = null # resourcið/húsið sem er targetað/valið
var on_complete: Callable = Callable() # Kallað þegar worker er búinn með taskið

func _init(
	_type: Type,
	_position: Vector3,
	_target: Node = null,
	_on_complete: Callable = Callable()
) -> void:
	
	type = _type
	target_position = _position
	target_node = _target
	on_complete = _on_complete
	
	
