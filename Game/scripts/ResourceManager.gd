extends Node

signal resources_changed(resource_type: String, new_amount: int)
signal resource_empty(resource_type: String)

var resources = {
	"wood": 100,
	"stone": 50,
	"food": 200,
}

func get_amount(type: String) -> int:
	return resources.get(type)

func has_enough(type: String, amount: int) -> bool:
	return get_amount(type ) >= amount

func add(type: String, amount: int) -> void:
	if not resources.has(type):
		print("Unknown resource type: " + type)
	resources[type] += amount
	emit_signal("resources_changed", type, resources[type])

func spend(type: String, amount: int) -> bool:
	if not has_enough(type, amount):
		return false
		print("Unknown resource type: " + type)
	resources[type] -= amount
	emit_signal("resources_changed", type, resources[type])
	if resources[type] <= 0:
		emit_signal("resources_empty", type)
	return true

func spend_multiple(costs: Dictionary) -> bool:
	for type in costs:
		if not has_enough(type, costs[type]):
			return false
	for type in costs:
		spend(type, costs[type])
	return true
		
		
		
		
		
		
		
		
		
		
