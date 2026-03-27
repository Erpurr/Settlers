extends Node

var grid_cell: Vector2i

func initialize(cell: Vector2i) -> void:
	grid_cell = cell
	Gridmap.occupy_cell(cell, self)

func _exit_tree() -> void:
	Gridmap.free_cell(grid_cell)
