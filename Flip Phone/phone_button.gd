extends Button
signal number_pressed(number)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	print('Tring to press')
	emit_signal('number_pressed', self.name)
	pass # Replace with function body.
