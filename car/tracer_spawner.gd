extends Node

const tracer_scene : PackedScene = preload("res://car/tracer.tscn")


func _ready() -> void:
	SignalBus.car_created.connect(func(car): 
		car.data_point_created.connect(on_data_point_created)
		)
	
func on_data_point_created(car : Car):
	var tracer = tracer_scene.instantiate()
	car.add_sibling(tracer)
	tracer.global_position = car.global_position
	tracer.set_car_and_time(car, floor(Simulation.time))
