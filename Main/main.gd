extends Node2D
@export var skeleton_scene: PackedScene

var window_size
var high_score: int = 0
var hard_enemies_on: bool = false
var enemy_counter: int = 0
@export var skip_menu: bool = true

signal shoot_text(text:String)

func _ready() -> void:
	$Game/SpawnTimer.stop()
	$Game/UI/GameTimer.stop()
	if !skip_menu:
		$"Game/UI".visible = false
	else:
		get_tree().paused = true
		self._on_main_menu_start()
		
	window_size = get_viewport_rect().size

func _on_spawn_timer_timeout() -> void:
	enemy_counter += 1
	var enemy_will_be_hard = false
	if enemy_counter % 5 == 0:
		enemy_will_be_hard = true
	var new_skeleton = skeleton_scene.instantiate()
	
	new_skeleton.position.y = randf_range(300, window_size.y -100)
	new_skeleton.position.x = window_size.x + 50
	new_skeleton.z_index = floor(new_skeleton.position.y/10.0)
	new_skeleton.can_spawn_hard = hard_enemies_on
	new_skeleton.is_hard = enemy_will_be_hard
	
	self.add_child(new_skeleton)
	
	new_skeleton.dead.connect(killed)
	new_skeleton.freeze.connect(freeze_screen)
	new_skeleton.kill.connect(kill_ray)

func killed(points, shoot_here: Vector2, clear_text):
	# Tell the UI to update score etc.
	$CameraPivot/Camera2D.shake(10)
	$Game/UI.add_points(points)
	$Game/FlipPhone.add_points(points)
	$Game/Character.player_shoot_laser(shoot_here)
	# Tell the phone to clear the text
	if clear_text:
		await $Game/FlipPhone.clear_text()
	var enemies = get_tree().get_nodes_in_group('enemy')
	for enemy: Node2D in enemies:
		print('Hitting them with the space')
		enemy.hit('')

func freeze_screen():
	var enemies = get_tree().get_nodes_in_group('enemy')
	$Game/FrostWindow.visible = true
	for enemy: Node2D in enemies:
		enemy.freeze_me()
	await get_tree().create_timer(5).timeout
	$Game/FrostWindow.visible = false

func kill_ray(number):
	var enemies = get_tree().get_nodes_in_group('enemy')
	enemies.sort_custom(func(a,b): return a.position.x < b.position.x)
	enemies = enemies.filter(func(a): 
		return !a.is_dying
	)
	var count: int = 0
	# Kill the closest $number
	# If too little on screen
	if number > enemies.size():
		number = enemies.size()
	for i in range(number):
		enemies[i].will_clear = false
		enemies[i].die()

func _on_flip_phone_shoot_text(text: String) -> void:
	#print('Main emitting signal with:', text)
	emit_signal('shoot_text', text)

func _on_difficulty_timer_timeout() -> void:
	hard_enemies_on = true

func _on_main_menu_start() -> void:
	print('Hey im trying to make fliphone visible')
	$"Main Menu".visible = false
	$Game/FlipPhone.visible = true
	$Game.visible = true
	$Game/UI.visible = true
	$Game/SpawnTimer.start()
	get_tree().paused = false
	$"Game/CharacterText".visible = true
	$"Game/CharacterText".start_talking()
	$Game/UI/GameTimer.start()


func _on_end_area_area_entered(area: Area2D) -> void:
	if area.is_in_group('enemy'):
		# End game
		$"Game/End Screen".visible = true
		$"Game/End Screen"/Score.visible = true
		$"Game/End Screen"/Score.text = str($Game/UI.score)
		var tween = get_tree().create_tween()
		clear_screen()
		tween.tween_property($"Game/End Screen", 'color', Color(0, 0, 0, 1), 3)
		print('Game fucking over bud')
		
func clear_screen():
	$Game/SpawnTimer.stop()
	var enemies = get_tree().get_nodes_in_group('enemy')
	for enemy: Node2D in enemies:
		enemy.queue_free()


func _on_retry_button_down() -> void:
	initialise()
	_on_main_menu_start()


func initialise():
	if $"Game/UI".score > high_score:
		high_score = $"Game/UI".score
		$HighScore.text = str(high_score)
	$"Game/UI".reset_points()
	$"Game/UI/GameTimer".stop()
	$Game/CharacterText.current_tab = 0
	$"Game/End Screen".color = Color(0,0,0,0)
	$"Game/End Screen".visible = false
	$Game/WinScreen.color = Color(0,0,0,0)
	$Game/WinScreen.visible = false
	$"Game/CharacterText".visible = false
	$Game/FlipPhone.clear_text()
	hard_enemies_on = false

	
func _on_menu_button_down() -> void:
	get_tree().paused = true
	initialise()
	$"Main Menu".visible = true
	$"Game".visible = false
	$Game/FlipPhone.visible = false


func _on_game_timer_timeout() -> void:
	$"Game/WinScreen".visible = true
	$Game/WinScreen/Score.text = str($Game/UI.score)
	clear_screen()
	var tween = get_tree().create_tween()
	tween.tween_property($"Game/WinScreen", 'color', Color(0, 0, 0, 1), 3)
	print('Win')


func _on_main_menu_survival() -> void:
	_on_main_menu_start()
	$Game/UI/GameTimer.stop()
	$Game/UI/GameTimerUI.visible = false
	$Game/UI/GameTimerLabel.visible = false
