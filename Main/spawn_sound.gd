extends AudioStreamPlayer
var playback
@export var sound_effects: Dictionary[ String, AudioStream ] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()
	playback = get_stream_playback()

func play_sound():
	var random_sound = randi_range(0,3)
	if sound_effects.has(str(random_sound)):
		var stream = sound_effects[str(random_sound)]
		playback.play_stream(stream)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
