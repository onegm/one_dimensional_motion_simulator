extends VBoxContainer

@export var h_flip : bool

var car : Car:
	set(new_car):
		car = new_car
		connect_signals()

@onready var position_controller := %PositionController
@onready var velocity_controller := %VelocityController
@onready var acceleration_controller := %AccelerationController

func connect_signals() -> void:
	position_controller.value_changed.connect(car.set_initial_position)
	velocity_controller.value_changed.connect(car.set_initial_velocity)
	acceleration_controller.value_changed.connect(car.set_acceleration)

func _ready() -> void:
	if !h_flip: return
	for row in get_children():
		if row is not HBoxContainer:
			continue
		row.move_child(row.get_child(0), -1)
		
