extends Node3D

@export_range(0, 1000) var movement_speed: float = 64
@export_range(0, 1000) var rotation_speed: float = 5
@export_range(0, 1000, 0.1) var zoom_speed: float = 50
@export_range(0, 1000) var min_zoom: float = 32
@export_range(0, 1000) var max_zoom: float = 256
@export_range(0, 90) var min_elevation_angle: float = 10
@export_range(0, 90) var max_elevation_angle: float = 90
@export var edge_margin: float = 50
@export var allow_rotation: bool = true
@export var allow_zoom: bool = true
@export var allow_pan: bool = true

@onready var camera = $Elevation/Camera3D
@onready var elevation_node = $Elevation

var is_rotating: bool = false
var is_panning: bool = false
var last_mouse_position: Vector2
var zoom_level: float = 64


func handle_keyboard_movement(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("camera_up"):
		direction.z -= 1
	if Input.is_action_pressed("camera_down"):
		direction.z += 1
	if Input.is_action_pressed("camera_left"):
		direction.x -= 1
	if Input.is_action_pressed("camera_right"):
		direction.x += 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		global_translate(direction * movement_speed * delta)
		
func _ready() -> void:
	zoom_level = camera.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_keyboard_movement(delta)
