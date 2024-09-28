extends Node2D
class_name Tracer

@onready var texture_rect := %TextureRect
@onready var properties = %Properties


func _ready() -> void:
	properties.visible = false
	texture_rect.mouse_entered.connect(func():properties.visible = true)
	texture_rect.mouse_exited.connect(func(): properties.visible = false)

func set_car_and_time(car : Car, time : float) -> void:
	%TimeLabel.text += str(time) + "s"
	%PositionLabel.text += str(round(car.get_current_position())) + "m"
	%VelocityLabel.text += str(round(car.velocity)) + "m/s"
	texture_rect.modulate = car.color
