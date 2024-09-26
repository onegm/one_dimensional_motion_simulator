extends Node2D
class_name Simulation

static var time := 0.0
static var cars := []

@onready var timer = $Timer

func _ready() -> void:
	set_process(false)
	timer.timeout.connect(SignalBus.data_point_requested.emit)
	SignalBus.simulation_started.connect(func():
		timer.start()
		set_process(true)
		)
	SignalBus.reset_simulation_pressed.connect(on_reset_simulation_pressed)
	
func _process(delta: float) -> void:
	time += delta

func on_reset_simulation_pressed():
	timer.stop()
	time = 0.0
	set_process(false)
	
