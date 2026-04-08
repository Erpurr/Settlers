extends Node3D

@export var building_scene: PackedScene
@export var ghost_color_ok: Color = Color(0.2, 0.8, 0.2, 0.4)
@export var ghost_color_bad: Color = Color(0.8, 0.2, 0.2, 0.4)
@export var camera: Camera3D


var _ghost: Node3D = null
var _is_placing: bool = false


func _on_build_button_pressed() -> void:
	print(1)
	start_placement()

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if _is_placing:
		_update_ghost()
		
func _unhandled_input(event: InputEvent) -> void:
	# Ef það er cancelað að placea með ui
	if event.is_action_pressed("ui_cancel"):
		cancel_placement()
	
	# Ef það er left clickað er reynt að placea
	if _is_placing and event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_try_place()


func start_placement() -> void:
	if _is_placing:
		return
	_is_placing = true
	_ghost = building_scene.instantiate()
	add_child(_ghost)
	_set_ghost_material(ghost_color_ok)

func cancel_placement() -> void:
	if _ghost:
		_ghost.queue_free()
		_ghost = null
	_is_placing = false


func _update_ghost() -> void:
	var ground_pos := _raycast_to_ground()
	if ground_pos == Vector3.ZERO:
		return
	
	var snapped: Vector3 = Gridmap.snap_to_grid(ground_pos)
	_ghost.global_position = snapped
	
	var cell := Gridmap.world_to_cell(snapped)
	var can_place := not Gridmap.is_cell_occupied(cell)
	_set_ghost_material(ghost_color_ok if can_place else ghost_color_bad)
	
func _try_place() -> void:
	var ground_pos := _raycast_to_ground()
	if ground_pos == null:
		return
	
	var snapped := Gridmap.snap_to_grid(ground_pos)
	var cell = Gridmap.world_to_cell(snapped)
	
	if Gridmap.is_cell_occupied(cell):
		return
	
	var building: Node3D = building_scene.instantiate()
	get_tree().current_scene.add_child(building)
	building.global_position = snapped
	
	if not building.initialize(cell):
		print("Not enough resources.")
	
func _raycast_to_ground() -> Vector3:
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_dir := camera.project_ray_normal(mouse_pos)
	
	#
	if abs(ray_dir.y) < 0.001:
		return Vector3.ZERO
	var t := -ray_origin.y / ray_dir.y
	# Ef groundið er fyrir aftan myndavélina
	if t < 0:
		return Vector3.ZERO
	
	return ray_origin + ray_dir * t
	
func _set_ghost_material(color: Color) -> void:
	if _ghost == null:
		return
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	for child in _ghost.get_children():
		if child is MeshInstance3D:
			child.material_override = mat
	
