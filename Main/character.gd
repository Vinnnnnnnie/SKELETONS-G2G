extends AnimatedSprite2D

var aim
@export var laser_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_finished() -> void:
	if self.animation == 'zap':
		self.play('default')

func player_shoot_laser(aim_here: Vector2):
	# instance laser
	var new_laser = laser_scene.instantiate()
	new_laser.laser_start = $LaserStart.position
	new_laser.laser_end = aim_here
	new_laser.position = Vector2(0,0)
	self.add_child(new_laser)
	
	self.play('zap')
	if !$LaserSound.playing:
		$LaserSound.play()

func _on_frame_changed() -> void:
	
	if (self.frame == 3 && self.animation == 'zap'):
		var lasers = get_tree().get_nodes_in_group('laser')
		for laser: Node2D in lasers:
			laser.fire_laser()
		$PhoneParticles.emitting = true
	else:
		$PhoneParticles.emitting = false
	
