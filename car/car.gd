extends Node2D
class_name Car

var initial_position : float = 0.0
var initial_velocity : float = 0.0
var velocity : float = 0.0
var acceleration : float = 0.0

signal data_point_created(car : Car)

func _ready() -> void:
	SignalBus.simulation_started.connect(start)
	SignalBus.data_point_requested.connect(data_point_created.emit.bind(self))
	SignalBus.reset_simulation_pressed.connect(on_reset_simulation_pressed)
	set_physics_process(false)
	SignalBus.car_created.emit(self)

func _physics_process(delta: float) -> void:
	position.x += velocity*delta + 0.5*acceleration*delta*delta
	velocity += acceleration*delta

func get_current_position():
	return position.x

func set_initial_velocity(vx : float):
	velocity = vx
	initial_velocity = vx
	
func set_initial_position(pos : float):
	initial_position = pos
	position.x = pos

func set_acceleration(ax : float):
	acceleration = ax

func start():
	data_point_created.emit(self)
	set_physics_process(true)

func on_reset_simulation_pressed():
	position.x = initial_position
	velocity = initial_velocity
	set_physics_process(false)
