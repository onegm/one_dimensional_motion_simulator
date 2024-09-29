extends Control

@export var car_a : Car
@export var car_b : Car

@onready var start_button := %StartButton
@onready var pause_button := %PauseButton
@onready var reset_button := %ResetButton
@onready var reset_properties_button := %ResetPropertiesButton

func _ready() -> void:
	start_button.pressed.connect(on_start_button_pressed)
	pause_button.pressed.connect(on_pause_button_pressed)
	reset_button.pressed.connect(on_reset_button_pressed)
	reset_properties_button.pressed.connect(SignalBus.reset_properties_requested.emit)
	
	%PropertiesA.car = car_a
	%PropertiesB.car = car_b

func on_start_button_pressed():
	SignalBus.start_simulation_requested.emit()
	start_button.disabled = true
	pause_button.disabled = false
	reset_button.disabled = false
	reset_properties_button.disabled = true
	
func on_pause_button_pressed():
	SignalBus.pause_simulation_requested.emit()
	reset_properties_button.disabled = !reset_properties_button.disabled

func on_reset_button_pressed():
	SignalBus.reset_simulation_requested.emit()
	get_tree().paused = false
	start_button.disabled = false
	pause_button.button_pressed = false
	pause_button.disabled = true
	reset_button.disabled = true
	reset_properties_button.disabled = false
	
