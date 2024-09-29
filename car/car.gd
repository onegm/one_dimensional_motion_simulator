#@tool
extends Node2D
class_name Car

@export var color : Color :
	set(value):
		color = value
		$CarBody.modulate = color
		
var initial_position : float = 0.0
var initial_velocity : float = 0.0
var velocity : float = 0.0
var acceleration : float = 0.0

signal data_point_created(car : Car)

func _ready() -> void:
	SignalBus.simulation_started.connect(start)
	SignalBus.data_point_requested.connect(data_point_created.emit.bind(self))
	SignalBus.reset_simulation_requested.connect(on_reset_simulation_requested)
	set_process(false)
	SignalBus.car_created.emit(self)

func _process(delta: float) -> void:
	position.x += velocity*delta + 0.5*acceleration*delta*delta
	velocity += acceleration*delta
	if 1.0 / delta != 30.0:
		print(1.0/delta)

func set_initial_position(value : float) -> void:
	initial_position = value
	position.x = value

func get_current_position():
	return position.x

func set_initial_velocity(value : float):
	velocity = value
	initial_velocity = value

func set_acceleration(value : float):
	acceleration = value

func start():
	data_point_created.emit(self)
	set_process(true)

func on_reset_simulation_requested():
	position.x = initial_position
	velocity = initial_velocity
	set_process(false)
