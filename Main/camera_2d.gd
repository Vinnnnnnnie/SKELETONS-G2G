extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shake(power):
	var tween = get_tree().create_tween()
	for i in range(3):
		tween.tween_property(self, 'rotation', deg_to_rad(0.6), 0.06)
		tween.tween_property(self, 'rotation', deg_to_rad(-0.6), 0.06)
	tween.tween_property(self, 'rotation', 0, 0.03)
	
