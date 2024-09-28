extends Node

const tracer_scene : PackedScene = preload("res://tracer/tracer.tscn")

var tracers = []

func _ready() -> void:
	SignalBus.car_created.connect(func(car): 
		car.data_point_created.connect(on_data_point_created)
		)
	SignalBus.reset_simulation_pressed.connect(on_reset_simulation_pressed)
	
func on_data_point_created(car : Car):
	var tracer = tracer_scene.instantiate()
	car.add_sibling(tracer)
	tracer.global_position = car.global_position
	tracer.set_car_and_time(car, round(Simulation.time))
	tracers.append(tracer)

func on_reset_simulation_pressed():
	while !tracers.is_empty():
		tracers.pop_front().queue_free()
