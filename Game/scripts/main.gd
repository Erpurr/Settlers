extends Node3D

@export var worker_scene: PackedScene
@export var camera: Camera3D

var _worker: CharacterBody3D = null
"res://scenes/worker.tscn"
func _ready() -> void:
	
	_worker = worker_scene.instantiate()
	add_child(_worker)
	_worker.global_position = Vector3(0, 1, 0)

func _unhandled_input(event: InputEvent) -> void:
	if _worker == null:
		return
	
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			var target := _raycast_to_ground(mb.position)
			if target != Vector3.ZERO:
				_worker.move_to(target, func():
					print("Arrived!")
				)
func _raycast_to_ground(mouse_pos: Vector2) -> Vector3:
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
