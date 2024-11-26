extends VBoxContainer

@onready var position_graph : Graph2D = %PositionGraph
@onready var velocity_graph : Graph2D = %VelocityGraph

func _enter_tree() -> void:
	SignalBus.car_created.connect(add_car)
	SignalBus.reset_simulation_requested.connect(on_reset_simulation_requested)

func add_car(car : Car) -> void:
	await ready
	var position_series = LineSeries.new(car.color, 1.5)
	var velocity_series = LineSeries.new(car.color, 1.5)
	car.data_point_created.connect(func(this_car): 
		position_series.add_point(this_car.num_data_point_count, this_car.position.x)
		velocity_series.add_point(this_car.num_data_point_count, this_car.velocity)
		)
	position_graph.add_series(position_series)
	velocity_graph.add_series(velocity_series)

func on_reset_simulation_requested():
	position_graph.clear_data()
	velocity_graph.clear_data()
