extends Node2D
@export var speed: int = 20
@export var kill_word: String = ''
var original_kill_word: String;
var is_dying: bool = false
var ice_colour: Color = Color(0.2, 0.5, 0.8)
var hard_colour: Color = Color(0.8, 0.3, 0.3)
var can_spawn_hard: bool = true
var will_freeze_on_death: bool = false
var will_kill_on_death: bool = false
var is_frozen: bool = false
var original_speed: int
var original_modulation: Color
var is_hard: bool = false
var will_clear: bool = true

@onready var kill_word_node = $CenterContainer/KillWord

signal dead(points: int, aim_here:Vector2)
signal freeze()
signal kill(number: int)

func _ready() -> void:
	# Connect to the phone
	var main = get_tree().get_first_node_in_group('main')
	$Sprite2D.play("walking")
	$GrumbleTimer.wait_time = randf_range(5, 15)
	$Grumble.pitch_scale = randf_range(0.5, 1.5)
	
	$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1)
	
	if main:
		main.shoot_text.connect(hit)
	# Choose kill word
	kill_word = random_kill_word()
	if is_hard:
		# This is a hard skele
		kill_word = random_hard_kill_word()
		var skeleton_type = randi_range(1, 3)
		print('Skeleton type:', skeleton_type)
		if skeleton_type == 3:
			# must have freeze on die
			will_freeze_on_death = true
			$Sprite2D.modulate = ice_colour
			$IceParticles.emitting = true
		else:
			will_kill_on_death = true
			speed = 28
			$FireParticles.emitting = true
			$Sprite2D.modulate = hard_colour
	
	kill_word_node.text = kill_word
	original_speed = speed
	original_modulation = $Sprite2D.modulate
	original_kill_word = kill_word

func _process(delta: float) -> void:
	if !is_dying && !is_frozen:
		position.x -= speed * delta

func hit(text):
	if (is_dying):
		return
	var semi_match = false
	var identical = true
	var last_character = text.right(1)
	var last_character_position = len(text)
	var letters_correct = 0
	var loop_total = original_kill_word.length()
	
	if original_kill_word.length() > text.length():
		loop_total = text.length()
		
	# if all the letters are equal so far
	for count in range(loop_total):
		print(text[count].to_lower(), ' == ', original_kill_word[count], '?')
		if text[count].to_lower() == original_kill_word[count]:
			identical = true
			letters_correct += 1
		else:
			identical = false
	
	if identical:
		print('I am identical so far')
	
	if letters_correct > 0:
		print("Original: ", original_kill_word)
		print("Input: ", text.to_lower())
		# find end of matching stuff
		
		kill_word_node.text = ''
		kill_word_node.push_color(Color.YELLOW)
		kill_word_node.push_bold()
		kill_word_node.append_text(original_kill_word.left(letters_correct))
		kill_word_node.pop()
		kill_word_node.pop()
		kill_word_node.append_text(original_kill_word.right(-letters_correct))
	else:
		kill_word_node.text = original_kill_word
		
	if text.to_lower() == original_kill_word:
		die()

func die():
	var points = 50 * len(kill_word)
	remove_child($CenterContainer)
	is_dying = true
	$Sprite2D.play("death")
	var shoot_here = self.global_position
	emit_signal("dead", points, shoot_here, will_clear)
	await get_tree().create_timer(1.0).timeout
	$AudioStreamPlayer.play()
	if will_freeze_on_death:
		await get_tree().create_timer(2.5).timeout
		$IceSound.play()

	
func freeze_me():
	$Ice.visible = true
	is_frozen = true
	$Sprite2D.pause()
	$FrozenTimer.start()
func random_hard_kill_word():
	var hard_kill_words = [
			'2nite', 
			'ur m9', 
			'lmfao', 
			'4ever',
			'snowy',
			'laser',
			'iceice',
			'chilly',
			'megalsr',
			'wipe em'
		]
	return hard_kill_words[randi_range(0,hard_kill_words.size() - 1)]
func random_kill_word():
	var easy_kill_words = [
		# 2 letters
		'kk', 'gn', 'jk', 'zz',
		# 3 letters
		'pew', 'zap', 'pow', 'brr', 'g2g', 'die', 'omg', 'gr8', 'idk', 'irl','soz', 
		'wtv', 'pls', 'imo', 'hmu', 'cya', 'lol', 'brb', '666',
		# 4 letters
		'no u', '1337', 'kill', 'ttyl', 'thnx', 'wuu2', 'xoxo', 'bang', 'lmao',
	]
		
	#hard_kill_words = [
			#'iceices',
			#'diedies',
		#]
	
	var kill_words = easy_kill_words
	
	return kill_words[randi_range(0,kill_words.size() - 1)]

func _on_sprite_2d_animation_finished() -> void:
	if will_freeze_on_death:
		print('Freezing on death :)))')
		emit_signal("freeze")
	elif will_kill_on_death:
		print('Killing on death :)))')
		emit_signal("kill", 3)
	if $Sprite2D.animation == 'death':
		queue_free()


func _on_frozen_timer_timeout() -> void:
	is_frozen = false
	speed = 10
	$Sprite2D.modulate = Color(0.3, 0.7, 0.8)
	$Ice.visible = false
	$Sprite2D.play()
	$SlowTimer.start()
	

func _on_slow_timer_timeout() -> void:
	speed = original_speed
	$Sprite2D.modulate = original_modulation
