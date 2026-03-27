extends Node

const CELL_SIZE := 2

var occupied_cells: Dictionary = {}

func world_to_cell(world_pos: Vector3) -> Vector2i:
	var col = int(floor(world_pos.x / CELL_SIZE))
	var row = int(floor(world_pos.z / CELL_SIZE))
	return Vector2i(col, row)

func cell_to_world(cell: Vector2i) -> Vector3:
	# +0.5 til að fá miðjuna á cellinu
	var x := (cell.x + 0.5) * CELL_SIZE
	var z := (cell.y + 0.5) * CELL_SIZE
	return Vector3(x, 0.0, z)
	
func snap_to_grid(world_pos: Vector3) -> Vector3:
	return cell_to_world(world_to_cell(world_pos))

func is_cell_occupied(cell: Vector2i) -> bool:
	return occupied_cells.has(cell)

func occupy_cell(cell: Vector2i, BuildingNode: Node) -> void:
	occupied_cells[cell] = BuildingNode

func free_cell(cell: Vector2i) -> void:
	occupied_cells.erase(cell)
