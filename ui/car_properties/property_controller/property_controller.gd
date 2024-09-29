extends HBoxContainer

@export var min_slider_value : int
@export var max_slider_value : int
@export var arrow_step : int
@export_range(0, 4) var max_digits : int

@onready var slider := %Slider
@onready var spin_box := %SpinBox

signal value_changed(value : float)

func _ready() -> void:
	slider.min_value = min_slider_value
	slider.max_value = max_slider_value
	
	spin_box.min_value = -(10**max_digits)
	spin_box.max_value = 10**max_digits
	spin_box.custom_arrow_step = arrow_step
	
	slider.value_changed.connect(func(value): 
		spin_box.value = value
		value_changed.emit(float(value))
	)
	
	spin_box.value_changed.connect(func(value):
		slider.value = value
	)
	
	SignalBus.reset_properties_requested.connect(slider.set_value.bind(0))
