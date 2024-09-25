extends RigidBody2D
class_name Car

@export var acceleration : float

var current_time : int = 0
var initial_velocity : float = 0

@onready var initial_x_position = global_position.x
@onready var timer := $Timer

func _ready() -> void:
	SignalBus.simulation_started.connect(start)
	timer.timeout.connect(SignalBus.data_point_created.emit.bind(self))
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	linear_velocity.x += acceleration*delta
	move_and_collide(linear_velocity)

func get_current_position():
	return global_position.x - initial_x_position

func set_velocity(vx : float):
	linear_velocity.x = vx
	initial_velocity = vx

func set_acceleration(ax : float):
	acceleration = ax

func start():
	SignalBus.data_point_created.emit(self)
	if timer.is_stopped(): timer.start()
	set_physics_process(true)

func reset():
	timer.stop(false)
	current_time = 0
	linear_velocity.x = initial_velocity
