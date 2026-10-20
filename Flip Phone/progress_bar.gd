extends ProgressBar
var timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $"../ButtonCycleTimer"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.value = timer.time_left * 100
	pass
