extends Node2D
class_name Simulation


static var time := 0.0

@onready var timer = $Timer

func _ready() -> void:
	set_process(false)
	timer.timeout.connect(SignalBus.data_point_requested.emit)
	SignalBus.simulation_started.connect(func():
		set_process(true)
		timer.start()
		)
	SignalBus.reset_simulation_requested.connect(on_reset_simulation_requested)
	
func _process(delta: float) -> void:
	time += delta

func on_reset_simulation_requested():
	timer.stop()
	time = 0.0
	set_process(false)
	
