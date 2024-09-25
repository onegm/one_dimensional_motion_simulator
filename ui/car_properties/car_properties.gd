extends VBoxContainer

@export var h_flip : bool:
	set(value):
		h_flip = value
		flip_h()

var car : Car:
	set(new_car):
		car = new_car
		connect_sliders()

@onready var position_slider : HSlider = %PositionSlider
@onready var position_label : Label = %PositionLabel
@onready var velocity_slider : HSlider = %VelocitySlider
@onready var velocity_label : Label = %VelocityLabel
@onready var acceleration_slider : HSlider = %AccelerationSlider
@onready var acceleration_label : Label = %AccelerationLabel

func _ready() -> void:
	position_slider.value_changed.connect(func(value): position_label.text = str(value))
	velocity_slider.value_changed.connect(func(value): velocity_label.text = str(value))
	acceleration_slider.value_changed.connect(func(value): acceleration_label.text = str(value))

func connect_sliders():
	position_slider.value_changed.connect(car.set_initial_position)
	velocity_slider.value_changed.connect(car.set_initial_velocity)
	acceleration_slider.value_changed.connect(car.set_acceleration)

func flip_h():
	for row in get_children():
		if row is not HBoxContainer:
			continue
		row.move_child(row.get_child(0), -1)
		
