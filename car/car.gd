class_name Car extends Node2D

@export var color : Color :
	set(value):
		color = value
		$CarBody.modulate = color
		
var initial_position : float = 0.0
var pause_position : float = 0.0
var initial_velocity : float = 0.0
var pause_velocity : float = 0.0
var velocity : float = 0.0
var acceleration : float = 0.0
var time : float = 0.0
var calibration_time : float = 0.0
var num_data_point_count : int = 0

signal data_point_created(car : Car)

func _ready() -> void:
	SignalBus.start_simulation_requested.connect(on_start)
	SignalBus.pause_simulation_requested.connect(on_pause)
	SignalBus.reset_simulation_requested.connect(on_reset)
		
	SignalBus.car_created.emit(self)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	time += delta
	position.x += velocity*delta + 0.5*acceleration*delta*delta
	velocity += acceleration*delta
	if time >= 1.0:
		calibration_time += 1.0
		recalibrate_position_and_velocity()
		num_data_point_count += 1
		time -= 1.0
		data_point_created.emit(self)

func recalibrate_position_and_velocity() -> void:
	position.x = pause_position + pause_velocity*calibration_time + 0.5*acceleration*calibration_time*calibration_time
	velocity = pause_velocity + acceleration*calibration_time

func get_current_position():
	return position.x

func set_initial_position(value : float) -> void:
	initial_position = value
	pause_position = value
	position.x = value

func set_initial_velocity(value : float):
	velocity = value
	pause_velocity = value
	initial_velocity = value

func set_acceleration(value : float):
	acceleration = value

func on_start():
	data_point_created.emit(self)
	set_physics_process(true)

func on_pause():
	calibration_time += time
	recalibrate_position_and_velocity()
	
	pause_position = position.x
	pause_velocity = velocity
	calibration_time = -time

func on_reset():
	position.x = initial_position
	pause_position = initial_position
	velocity = initial_velocity
	pause_velocity = initial_velocity
	time = 0.0
	calibration_time = 0.0
	num_data_point_count = 0
	set_physics_process(false)
