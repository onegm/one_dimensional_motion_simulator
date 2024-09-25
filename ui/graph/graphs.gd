extends VBoxContainer

var colors = [Color.RED, Color.BLUE]

@onready var position_graph : Graph2D = %PositionGraph
@onready var velocity_graph : Graph2D = %VelocityGraph

func _enter_tree() -> void:
	SignalBus.car_created.connect(add_car)

func add_car(car : Car) -> void:
	await ready 
	var color = colors.pop_front()
	var position_series = position_graph.add_plot_item(car.name, color)
	var velocity_series = velocity_graph.add_plot_item(car.name, color)
	car.data_point_created.connect(func(this_car): 
		position_series.add_point(Vector2(Simulation.time, this_car.position.x))
		velocity_series.add_point(Vector2(Simulation.time, this_car.velocity))
		)
