extends VBoxContainer

@onready var position_graph : Graph2D = %PositionGraph
@onready var velocity_graph : Graph2D = %VelocityGraph

func _enter_tree() -> void:
	SignalBus.car_created.connect(add_car)
	SignalBus.reset_simulation_requested.connect(on_reset_simulation_requested)

func add_car(car : Car) -> void:
	await ready
	var position_series = position_graph.add_plot_item(" ", car.color)
	var velocity_series = velocity_graph.add_plot_item(" ", car.color)
	car.data_point_created.connect(func(this_car): 
		position_series.add_point(Vector2(Simulation.time, this_car.get_current_position()))
		velocity_series.add_point(Vector2(Simulation.time, this_car.velocity))
		)

func on_reset_simulation_requested():
	for plot in position_graph._plots:
		plot.remove_all()
	for plot in velocity_graph._plots:
		plot.remove_all()
