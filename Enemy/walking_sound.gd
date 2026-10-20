extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pitch_scale = randf_range(0.8, 1.2)
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finished() -> void:
	play()
