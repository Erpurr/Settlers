extends CharacterBody3D

enum State {
	IDLE,
	MOVING
}

var state: State = State.IDLE

@export var move_speed: float = 4.0
@export var arrival_distance: float = 0.5

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var _on_arrived: Callable

func _ready() -> void:
	# Vandamál með að worker myndi ekki hreyfast lagað með því að leyfa NavigationServernum að loadast alveg
	await get_tree().process_frame
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	
func _physics_process(delta: float) -> void:
	
	match state:
		State.IDLE:
			pass
		State.MOVING:
			_handle_movement()

func move_to(target_pos: Vector3, on_arrived: Callable = Callable()) -> void:
	
	nav_agent.target_position = target_pos
	_on_arrived = on_arrived
	state = State.MOVING

func _handle_movement() -> void:
	if nav_agent.is_navigation_finished():
		_arrive()
		return
	
	var next_pos := nav_agent.get_next_path_position()
	var direction := (next_pos - global_position).normalized()
	nav_agent.velocity = Vector3(direction.x, 0.0, direction.z) * move_speed

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z
	move_and_slide()

func _arrive() -> void:
	velocity = Vector3.ZERO
	state = State.IDLE
	if _on_arrived.is_valid():
		_on_arrived.call()
		_on_arrived = Callable() # Cleara
