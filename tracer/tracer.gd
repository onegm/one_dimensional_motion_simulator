extends Node2D
class_name Tracer

@onready var texture_rect := %TextureRect
@onready var properties = %Properties


func _ready() -> void:
	properties.visible = false
	texture_rect.mouse_entered.connect(func():properties.visible = true)
	texture_rect.mouse_exited.connect(func(): properties.visible = false)

func set_data(time : int, x_position : float, velocity : float, color : Color) -> void:
	%TimeLabel.text += str(time) + "s"
	%PositionLabel.text += str(round(x_position)) + "m"
	%VelocityLabel.text += str(round(velocity)) + "m/s"
	texture_rect.modulate = color
