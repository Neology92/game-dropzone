class_name Player extends Node2D

var track_idx: int

func _ready() -> void:
	@warning_ignore("integer_division")
	track_idx = GameManager.instance.tracks.size() / 2

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
	track_idx = clamp(track_idx + direction, 0, GameManager.instance.tracks.size() - 1)
	change_track()



func change_track() -> void:
	var target_track = GameManager.instance.tracks[track_idx]

	reparent(target_track.player_slot)
	position = Vector2.ZERO  

func kill() -> void:
	print("Player killed")
	get_tree().quit()  # End the game or handle player death
	# Optionally, you can also reset the game state or show a game over screen here.
