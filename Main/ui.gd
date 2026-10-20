extends Control
var score: int = 0

func add_points(points):
	print('Adding points: ', points)
	score += points
	$Score.text = str(score)
	
func reset_points():
	score = 0
	$Score.text = str(score)

func _process(delta: float) -> void:
	$GameTimerUI.text = str(round($GameTimer.time_left))
