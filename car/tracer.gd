extends Area2D
class_name Tracer

@onready var properties = %Properties

func _ready() -> void:
	properties.visible = false
	mouse_entered.connect(func():properties.visible = true)
	mouse_exited.connect(func(): properties.visible = false)

func set_car_and_time(car : Car, time : float) -> void:
	%TimeLabel.text += str(time) + "s"
	%PositionLabel.text += str(round(car.get_current_position())) + "m"
	%VelocityLabel.text += str(round(car.linear_velocity.x)) + "m/s"
