extends Control
var speed = -420
var should_move = true
var slow_down = 169
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().create_timer(0.5).timeout
	print('Ready to tween')
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if should_move:
		position.y += speed * delta
		speed += slow_down * delta
		if speed > -20:
			slow_down = 0
		if position.y < 140:
			should_move = false
	
