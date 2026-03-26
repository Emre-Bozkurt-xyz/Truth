extends Control

signal choice_selected(choice_id)

@export var button_scene: PackedScene  # Custom button scene if desired

var choices: Array = []

func setup(choice_list: Array):
	choices = choice_list
	_create_choice_buttons()

func _create_choice_buttons():
	# Clear existing buttons
	for child in $ButtonsContainer.get_children():
		child.queue_free()
	
	# Create buttons horizontally
	var hbox = HBoxContainer.new()
	hbox.name = "ButtonsContainer"
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	for choice in choices:
		var button = Button.new()
		button.text = choice["text"]
		button.custom_minimum_size = Vector2(200, 60)
		
		# Style your button
		button.add_theme_stylebox_override("normal", _create_button_style("#2c3e50"))
		button.add_theme_stylebox_override("hover", _create_button_style("#34495e"))
		button.add_theme_stylebox_override("pressed", _create_button_style("#1a2632"))
		
		button.add_theme_font_size_override("font_size", 20)
		button.add_theme_color_override("font_color", Color.WHITE)
		
		button.pressed.connect(_on_button_pressed.bind(choice["signal"]))
		hbox.add_child(button)
	
	add_child(hbox)
	$ButtonsContainer = hbox

func _create_button_style(color: String) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(color)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style

func _on_button_pressed(signal_name: String):
	choice_selected.emit(signal_name)
	hide()
