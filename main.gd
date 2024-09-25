extends Control

@export var car_a : Car
@export var car_b : Car

@onready var start_button := %StartButton
@onready var pause_button := %PauseButton
@onready var reset_button := %ResetButton

func _ready() -> void:
	start_button.pressed.connect(on_start_button_pressed)
	pause_button.pressed.connect(func(): get_tree().paused = !get_tree().paused)
	reset_button.pressed.connect(SignalBus.reset_simulation_pressed.emit)
	
	%PropertiesA.car = car_a
	%PropertiesB.car = car_b

func on_start_button_pressed():
	SignalBus.simulation_started.emit()
	get_tree().paused = false
