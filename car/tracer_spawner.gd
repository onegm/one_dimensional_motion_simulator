extends Node

const tracer_scene : PackedScene = preload("res://car/tracer.tscn")

var current_time : float = 0

func _ready() -> void:
	SignalBus.data_point_created.connect(on_data_point_created)

func on_data_point_created(car : Car):
	var tracer = tracer_scene.instantiate()
	car.add_sibling(tracer)
	tracer.global_position = car.global_position
	tracer.set_car_and_time(car, floor(current_time))
	current_time += 0.5
