extends Node

var grid_cell: Vector2i

func get_cost() -> Dictionary:
	return {"wood": 10, "stone": 15}

func initialize(cell: Vector2i) -> bool:
	# Cancelar ef það eru ekki til nóg resources/materials
	if not ResourceManager.spend_multiple(get_cost()):
		queue_free()
		return false
	grid_cell = cell
	Gridmap.occupy_cell(cell, self)
	return true

func _exit_tree() -> void:
	Gridmap.free_cell(grid_cell)
