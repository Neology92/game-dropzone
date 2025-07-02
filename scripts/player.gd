class_name Player extends Node2D

var track_idx: int
@onready var image = %Image

var _default_image_scale
var bump_scale: float = 0.8

var swish_sounds: Array = [
	preload("res://assets/sfx/swish_1.mp3"),
	preload("res://assets/sfx/swish_2.mp3"),
]


func _ready() -> void:
	@warning_ignore("integer_division")
	track_idx = GameManager.instance.tracks.size() / 2
	change_track()
	self.connect("ready", _on_ready)

func _on_ready() -> void:
	_default_image_scale = image.scale

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_LEFT:
					move(-1)
				KEY_RIGHT:
					move(1)
				KEY_ESCAPE:
					get_tree().quit()
				_:
					print("Unhandled key pressed: ", event.keycode)
					pass


func move(direction: int) -> void:
	animate_bump()
	play_sound(swish_sounds.pick_random())
	track_idx = clamp(track_idx + direction, 0, GameManager.instance.tracks.size() - 1)
	change_track()


func change_track() -> void:
	var target_track = GameManager.instance.tracks[track_idx]
	var next_pos = target_track.player_slot.global_position
	animate_move(next_pos)

func kill() -> void:
	print("Player killed")
	get_tree().quit()  


func animate_move(_target_pos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", _target_pos, 0.05)
	tween.set_ease(Tween.EASE_IN_OUT)


func animate_bump() -> void:
	image.scale = _default_image_scale * bump_scale
	await get_tree().create_timer(0.1).timeout
	image.scale = _default_image_scale


func play_sound(sound: AudioStream) -> void:
	var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_player.stream = sound
	audio_player.volume_db = 25
	audio_player.bus = "sfx"  # Ensure this matches your audio bus setup
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()  # Clean up after the sound has finished playing