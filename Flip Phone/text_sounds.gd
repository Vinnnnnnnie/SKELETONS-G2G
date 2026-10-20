extends AudioStreamPlayer
var playback
@export var sound_effects: Dictionary[ String, AudioStream ] = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()
	playback = get_stream_playback()

func play_sound(sound):
	if sound_effects.has(sound):
		var stream = sound_effects[sound]
		playback.play_stream(stream)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
