extends Button

signal play_sound(sound_number: int)
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func _on_button_down() -> void:
	emit_signal('play_sound', '1')
