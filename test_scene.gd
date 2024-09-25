extends Control

@onready var graph : Graph2D = $Graph2D
var i = 0
var series : PlotItem

func _ready() -> void:
	series = graph.add_plot_item("NAME", Color.BLUE, 1.0)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		series.add_point(Vector2(i, i*i))
		i += 1	
