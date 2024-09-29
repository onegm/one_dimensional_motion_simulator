@tool
extends HBoxContainer

@export var min_slider_value : int
@export var max_slider_value : int
@export var tick_count : int
@export var arrow_step : int
@export_range(0, 4) var max_digits : int

@onready var slider := %Slider
@onready var spin_box := %SpinBox

signal value_changed(value : float)

func _ready() -> void:
	SignalBus.start_simulation_requested.connect(on_start)
	SignalBus.pause_simulation_requested.connect(on_pause)
	SignalBus.reset_simulation_requested.connect(on_pause)
	SignalBus.reset_properties_requested.connect(slider.set_value.bind(0))
	
	assign_controller_properties()
	connect_components()
	
	if !Engine.is_editor_hint():
		set_process(false)

func assign_controller_properties():
	slider.min_value = min_slider_value
	slider.max_value = max_slider_value
	slider.tick_count = tick_count
	
	spin_box.min_value = -(10**max_digits)
	spin_box.max_value = 10**max_digits
	spin_box.custom_arrow_step = arrow_step

func connect_components():
	slider.value_changed.connect(func(value): 
		spin_box.value = value
		value_changed.emit(float(value))
	)
	
	spin_box.value_changed.connect(func(value):
		slider.value = value
	)

func on_start():
	slider.editable = false
	spin_box.editable = false

func on_pause():
	slider.editable = !slider.editable
	spin_box.editable = !spin_box.editable

func _process(delta: float) -> void:
	assign_controller_properties()
