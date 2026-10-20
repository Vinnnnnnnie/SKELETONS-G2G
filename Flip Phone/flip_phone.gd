extends Control
signal shoot_text(text:String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_screen_text_updated(text: String) -> void:
	emit_signal('shoot_text', text)


func _on_button_cycle_timer_timeout() -> void:
	pass # Replace with function body.

func add_points(points):
	pass

func clear_text():
	$TextureRect/Screen/Text.text = ''
	$TextureRect/Screen.new_character = ''
	$"TextureRect/Keypad/Keypad Container/ButtonCycleTimer".stop()
	$"TextureRect/Keypad/Keypad Container".same_press = 0


func _on__number_pressed(number: Variant) -> void:
	var x_tilt = 0.0
	var y_tilt = 0.0
	var tilt_value = 0.03
	var x_direction = 0.0
	var y_direction = 0.5
	
	match number:
		'1':
			x_tilt = tilt_value
		'2':
			pass
		'3':
			x_direction = 1
			x_tilt = tilt_value
		'4':
			x_tilt = tilt_value
		'5':
			pass
		'6':
			x_tilt = tilt_value
			x_direction = 1
		'7':
			x_tilt = tilt_value
		'8':
			pass
		'9':
			x_tilt = tilt_value
			x_direction = 1
		'*':
			x_tilt = tilt_value
		'0':
			pass
		'#':
			x_tilt = tilt_value
			x_direction = 1
	
	$TextureRect.scale = Vector2(0.98, 0.98)
	$TextureRect.material.set_shader_parameter("depth_distortion", x_tilt)
	$TextureRect.material.set_shader_parameter("pivot_x", x_direction)

	await get_tree().create_timer(0.2).timeout
	$TextureRect.material.set_shader_parameter("depth_distortion", 0.0)
	$TextureRect.material.set_shader_parameter("pivot_x", 0.0)
	$TextureRect.scale = Vector2(1, 1)
	pass # Replace with function body.
