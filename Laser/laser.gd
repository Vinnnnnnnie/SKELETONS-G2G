extends Line2D
var laser_start: Vector2
var laser_end: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	print('Laser starting here: ', laser_start,' /n and ending here: ', laser_end)
	if laser_start:
		self.set_point_position(0, laser_start)
	else:
		self.set_point_position(0, Vector2(400, 400))
	
	if laser_end:
		self.set_point_position(1, laser_end - global_position)
	else:
		self.set_point_position(1, Vector2(500, 500))

	$LaserEndParticles.position = laser_end - global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func fire_laser():
	
	# Work out laser midpoint
	var start = self.get_point_position(0)
	var end = self.get_point_position(1)
	var midpoint = (start + end) / 2
	var angle = start.angle_to_point(end)
	$LaserParticles.position =  midpoint
	$LaserParticles.rotation = angle
	
	# Show laser
	self.visible = true
	$LaserParticles.emitting = true
	$LaserEndParticles.emitting = true
	
	
	# Time laser show
	$LaserTimer.start()


func _on_laser_timer_timeout() -> void:
	self.visible = false
	queue_free()
	pass # Replace with function body.
