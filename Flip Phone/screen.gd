extends Control
var new_character: String = ''
var is_potential: bool = false
var text_node
signal text_updated(text: String)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_node = $Text
	text_node.add_caret(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text_node.set_caret_column(len(text_node.text))
	
	
func _on_keypad_container_update_screen(character: String) -> void:
	# New possible character
	new_character = character
	#print('_on_keypad_container_update_screen(): Received new character', character)
	
	# update new potential text
	potential_text(new_character)
	emit_signal('text_updated', text_node.text)

func potential_text(new_character: String):
	# if in potential character mode
	if is_potential:
		print('potential_text(): This is a potential character')
		# remove the last potential character
		text_node.text = text_node.text.left(-1)
		# add new potential character
		text_node.text += new_character
		is_potential = true
	else:
		#print('potential_text(): Not potential')
		# No character to remove
		text_node.text += new_character
		#print('potential_text(): text after ',text_node.text)
		is_potential = true

	
func _on_keypad_container_submit() -> void:
	# Remove potential character
	print('_on_keypad_container_submit(): submitting...')
	text_node.text = text_node.text.left(-1)
	text_node.text += new_character
	is_potential = false


func _on_keypad_container_delete(is_timer_stopped) -> void:
	text_node.text = text_node.text.left(-1)
	new_character = ''
	is_potential = false
