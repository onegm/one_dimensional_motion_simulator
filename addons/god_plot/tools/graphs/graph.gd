@tool
class_name Graph extends Control
## Abstract class for creating graphs. Use inheriting classes instead.

@export var background_color : Color = Color.BLACK:
	set(value):
		background_color = value
		color_rect.color = background_color
		
@export var border_margin : float = 10.0:
	set(value):
		border_margin = max(0, value)
		graph_v_box.set_offsets_preset(PRESET_FULL_RECT, PRESET_MODE_MINSIZE, border_margin)

@export_group("Titles")
@export_multiline var title : String = "":
	set(value):
		title = value
		if is_node_ready(): graph_title.text = value
		graph_title.visible = !title.is_empty()

@export_range(0, 10) var title_size : float = 1.0:
	set(value):
		title_size = value
		_on_theme_changed()
		
@export var horizontal_title : String = "":
	set(value):
		horizontal_title = value
		if is_inside_tree(): x_axis_title.text = horizontal_title
		x_axis_title.visible = !horizontal_title.is_empty()
		
@export var vertical_title : String = "":
	set(value):
		vertical_title = value
		if is_inside_tree(): y_axis_title.text = vertical_title
		y_axis_title.visible = !vertical_title.is_empty()
		_update_y_axis_title_rotation_and_position()
		queue_redraw()

@export var rotated_v_title : bool = true:
	set(value):
		rotated_v_title = value
		_update_y_axis_title_rotation_and_position()
		queue_redraw()

@export var font_color : Color = Color.WHITE:
	set(value):
		font_color = value
		_set_label_colors(font_color)

@export_group("Axes")

@export var axis_color : Color = Color.WHITE:
	set(value):
		axis_color = value
		queue_redraw()
		
@export var axis_thickness: float = 3:
	set(value):
		axis_thickness = value
		queue_redraw()
		
@export_range(0, 5) var label_size : float = 1.0:
	set(value):
		label_size = value
		_on_theme_changed()
## Automatically adjusts axis min and max values to accommodate data. 
@export var auto_scaling : bool = true:
	set(value):
		auto_scaling = value
		queue_redraw()
		
@export var show_tick_labels: bool = true:
	set(value):
		show_tick_labels = value
		queue_redraw()
		
@export_group("X Axis", "x_")
## Minimum value on x-axis. Precision must match [member x_decimal_places]
@export var x_min: float = 0.0:
	set(value):
		x_min = Rounder.round_num_to_decimal_place(value, x_decimal_places)
		if x_min > x_max: x_max = x_min
		queue_redraw()
## Maximum value on x-axis. Precision must match [member x_decimal_places]
@export var x_max: float = 10.0:
	set(value):
		x_max = Rounder.round_num_to_decimal_place(value, x_decimal_places)
		if x_max < x_min: x_min = x_max
		queue_redraw()

## Number of major gridlines. May change to ensure accurate position of gridlines. 
## More [member x_decimal_places] results in less variation.
@export var x_tick_count: int = 10:
	set(value):
		x_tick_count = value
		queue_redraw()

@export_range(0, 5) var x_decimal_places : int = 1:
	set(value):
		x_decimal_places = value
		queue_redraw()
@export_subgroup("Gridlines", "x_gridlines")
@export_range(0, 1) var x_gridlines_opacity : float = 1.0:
	set(value):
		x_gridlines_opacity = value
		queue_redraw()

@export var x_gridlines_major_thickness : float = 1.0:
	set(value):
		x_gridlines_major_thickness = value
		queue_redraw()

@export_range(0, 10) var x_gridlines_minor : int = 0:
	set(value):
		x_gridlines_minor = value
		queue_redraw()

@export var x_gridlines_minor_thickness : float = 1.0:
	set(value):
		x_gridlines_minor_thickness = value
		queue_redraw()

@export_group("Y Axis", "y_")
## Minimum value on y-axis. Precision must match [member y_decimal_places]
@export var y_min: float = 0.0:
	set(value):
		y_min = Rounder.round_num_to_decimal_place(value, y_decimal_places)
		if y_min > y_max: y_max = y_min
		queue_redraw()
## Maximum value on y-axis. Precision must match [member y_decimal_places]
@export var y_max: float = 10.0:
	set(value):
		y_max = Rounder.round_num_to_decimal_place(value, y_decimal_places)
		if y_max < y_min: y_min = y_max
		queue_redraw()
## Number of major gridlines. May change to ensure accurate position of gridlines. 
## More [member y_decimal_places] results in less variation.
@export var y_tick_count: int = 10:
	set(value):
		y_tick_count = value
		queue_redraw()

@export_range(0, 5) var y_decimal_places : int = 1:
	set(value):
		y_decimal_places = value
		queue_redraw()
@export_subgroup("Gridlines", "y_gridlines")
@export_range(0, 1) var y_gridlines_opacity : float = 1.0:
	set(value):
		y_gridlines_opacity = value
		queue_redraw()
@export var y_gridlines_major_thickness : float = 1.0:
	set(value):
		y_gridlines_major_thickness = value
		queue_redraw()
@export_range(0, 10) var y_gridlines_minor : int = 0:
	set(value):
		y_gridlines_minor = value
		queue_redraw()
@export var y_gridlines_minor_thickness : float = 1.0:
	set(value):
		y_gridlines_minor_thickness = value
		queue_redraw()

var color_rect := ColorRect.new()
var graph_v_box := VBoxContainer.new()
var graph_title := Label.new() 
var x_axis_title := Label.new()
var y_axis_title := Label.new()

var pair_of_axes := PairOfAxes.new()
var plotter : Plotter = Plotter.new(pair_of_axes)

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_graph()
	theme_changed.connect(_on_theme_changed)

func _build_graph():
	_build_background()
	_build_vbox()

func _build_background():
	add_child(color_rect)
	color_rect.color = background_color
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _build_vbox():
	add_child(graph_v_box)
	graph_v_box.set_anchors_and_offsets_preset(PRESET_FULL_RECT, PRESET_MODE_MINSIZE, border_margin)
	graph_v_box.size_flags_horizontal = SIZE_EXPAND_FILL
	_build_graph_title()
	_build_pair_of_axes()
	_build_x_axis_title()

func _build_graph_title():
	graph_v_box.add_child(graph_title)
	graph_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	graph_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	graph_title.text = title
	graph_title.visible = !title.is_empty()

func _build_pair_of_axes():
	graph_v_box.add_child(pair_of_axes)
	pair_of_axes.resized.connect(queue_redraw)
	pair_of_axes.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_build_y_axis_title()
	
	pair_of_axes.add_child(plotter)

func _build_y_axis_title():
	pair_of_axes.add_child(y_axis_title)
	_update_y_axis_title_rotation_and_position()
	y_axis_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	y_axis_title.set_anchors_preset(Control.PRESET_CENTER_LEFT)	
	y_axis_title.text = vertical_title
	y_axis_title.visible = !vertical_title.is_empty()

func _update_y_axis_title_rotation_and_position():
	y_axis_title.size = y_axis_title.get_minimum_size()
	y_axis_title.pivot_offset = Vector2(y_axis_title.size.y/2, y_axis_title.size.y/2)
	if rotated_v_title:
		y_axis_title.rotation = -PI/2
		y_axis_title.position.y = pair_of_axes.size.y/2 + y_axis_title.size.x/3.0
	else:
		y_axis_title.rotation = 0
		y_axis_title.position.y = pair_of_axes.size.y/2

func _build_x_axis_title():
	graph_v_box.add_child(x_axis_title)
	x_axis_title.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	x_axis_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	x_axis_title.size_flags_vertical = SIZE_SHRINK_END
	x_axis_title.text = horizontal_title
	x_axis_title.visible = !horizontal_title.is_empty()

func _on_theme_changed():
	graph_title.add_theme_font_size_override("font_size", get_theme_font_size("", "") * title_size)
	if !is_node_ready(): return
	await get_tree().process_frame
	pair_of_axes.font_size = get_theme_font_size("", "") * label_size
	queue_redraw()
	
func _set_label_colors(label_color : Color) -> void:
	graph_title.add_theme_color_override("font_color", label_color)
	x_axis_title.add_theme_color_override("font_color", label_color)
	y_axis_title.add_theme_color_override("font_color", label_color)

func _draw() -> void:
	GraphToAxesMapper.map(self, pair_of_axes)
	pair_of_axes.queue_redraw()

func get_y_axis_title_width() -> float:
	if rotated_v_title and y_axis_title.visible:
		return y_axis_title.size.y
	return y_axis_title.size.x
