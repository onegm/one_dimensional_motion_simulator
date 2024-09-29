extends Control

@export var h_flip : bool
		
var car : Car:
	set(new_car):
		car = new_car
		self_modulate = car.color
		connect_signals()

@onready var position_controller := %PositionController
@onready var velocity_controller := %VelocityController
@onready var acceleration_controller := %AccelerationController

@onready var controllers := [position_controller, velocity_controller, acceleration_controller]

func _ready() -> void:
	check_h_flip()

func connect_signals() -> void:
	position_controller.value_changed.connect(car.set_initial_position)
	velocity_controller.value_changed.connect(car.set_initial_velocity)
	acceleration_controller.value_changed.connect(car.set_acceleration)
	
func check_h_flip() -> void:
	if !h_flip: return
	for row in controllers:
		row.move_child(row.get_child(0), -1)
