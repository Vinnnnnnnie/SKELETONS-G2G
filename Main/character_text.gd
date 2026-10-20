extends TabContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_talking():
	await get_tree().create_timer(4).timeout
	self.current_tab += 1
	await get_tree().create_timer(4).timeout
	self.current_tab += 1
	await get_tree().create_timer(4).timeout
	self.visible = false
