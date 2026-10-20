extends Control
var character: String = ''
var last_pressed = ''
var same_press: int = 0
signal update_screen(character: String)
signal submit()
signal delete(is_timer_stopped)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("0"):
		_on_number_pressed('0')
	elif Input.is_action_just_pressed("1"):
		_on_number_pressed('1')
	elif Input.is_action_just_pressed("2"):
		_on_number_pressed('2')
	elif Input.is_action_just_pressed("3"):
		_on_number_pressed('3')
	elif Input.is_action_just_pressed("4"):
		_on_number_pressed('4')
	elif Input.is_action_just_pressed("5"):
		_on_number_pressed('5')
	elif Input.is_action_just_pressed("6"):
		_on_number_pressed('6')
	elif Input.is_action_just_pressed("7"):
		_on_number_pressed('7')
	elif Input.is_action_just_pressed("8"):
		_on_number_pressed('8')
	elif Input.is_action_just_pressed("9"):
		_on_number_pressed('9')
	elif Input.is_action_just_pressed("0"):
		_on_number_pressed('0')
	elif Input.is_action_just_pressed("*"):
		_on_number_pressed('*')
	elif Input.is_action_just_pressed("#"):
		_on_number_pressed('#')
func handle_keyboard():
	pass
func _on_number_pressed(number: Variant) -> void:
	var text_array: Array = []
	$TextSounds.play_sound(number)
	match number:
		'1':
			text_array = ['1']
		'2':
			text_array = ['A', 'B', 'C', '2']
		'3':
			text_array = ['D', 'E', 'F', '3']
		'4':
			text_array = ['G', 'H', 'I', '4']
		'5':
			text_array = ['J', 'K', 'L', '5']
		'6':
			text_array = ['M', 'N', 'O', '6']
		'7':
			text_array = ['P', 'Q', 'R', 'S', '7']
		'8':
			text_array = ['T', 'U', 'V', '8']
		'9':
			text_array = ['W', 'X', 'Y', 'Z', '9']
		'*':
			# This is breaking delete again
			text_array = ['+']
			submit_character()
			same_press = 0
			return
		'0':
			text_array = [' ', '0']
		'#':
			# What to do on delete
			text_array = ['_delete_']
			# tell screen we deleted
			emit_signal('delete', $ButtonCycleTimer.is_stopped())
			same_press = 0
			last_pressed = 'delete'
			# stop timer
			$ButtonCycleTimer.stop()
			return
	if $ButtonCycleTimer.time_left < 1:
		# are we in cycle mode
		if (last_pressed == number):
			restart_timer()
			# We are cycling, where are we?
			same_press = same_press % text_array.size()
			character = text_array[same_press] 
			same_press += 1
			last_pressed = number
		else:
			# We start a new cycle
			restart_timer()
			# Submit the buffer
			# Do we need to do this
			if last_pressed != 'delete':
				submit_character()
			
			# reset same press
			same_press = 0
			character = text_array[same_press]
			same_press += 1
			last_pressed = number
	else:
		# We start a new cycle
		# Submit the buffer
		submit_character()
		
		restart_timer()
		same_press = 0
		
		character = text_array[same_press]
		same_press += 1
		last_pressed = number
		
	emit_signal("update_screen", character)

func restart_timer():
	# Restart timer
	$ButtonCycleTimer.stop()
	$ButtonCycleTimer.start()

func submit_character():
	emit_signal("submit")

func _on_button_cycle_timer_timeout() -> void:
	print(last_pressed)
	same_press = 0
	submit_character()
