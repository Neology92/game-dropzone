extends Node

var instance: GameManager

var music_player: AudioStreamPlayer2D = preload("res://scenes/music_player.tscn").instantiate()

var tracks = []
var player = preload("res://scenes/player.tscn").instantiate()

var game_timer = Timer.new()


var _music_bpm = music_player.stream.bpm
var _music_beat_duration = 60.0 / _music_bpm  # Duration

var current_track_idx: int


func _init() -> void:
	if instance:
		push_error("GameManager instance already exists!")
	else:
		instance = self

	add_child(game_timer)
	add_child(music_player)

func _ready() -> void:
	add_child(player)
	player.change_track()
	current_track_idx = randi() % tracks.size()

	move_blocks_down()
	generate_blocks()
	move_blocks_down()
	generate_blocks()

	start_game()

	
func start_game() -> void:
	print("Starting game")
	game_timer.wait_time = _music_beat_duration
	game_timer.one_shot = false
	game_timer.timeout.connect(on_game_timer_timeout)
	game_timer.start()
	music_player.play()


func on_game_timer_timeout() -> void:
	move_blocks_down()
	generate_blocks()

func move_blocks_down() -> void:
	for track in tracks:
		track.move_blocks_down()


func generate_blocks() -> void:
	var _row = []
	_row.resize(tracks.size())
	_row.fill(true)
	_row[current_track_idx] = false  # Leave the current track empty

	var next_track_idx = clamp(current_track_idx + [-1, 0, 1].pick_random(), 0, tracks.size() - 1)
	_row[next_track_idx] = false 
	for i in range(tracks.size()):
		if _row[i]:
			tracks[i].add_block()
	
	current_track_idx = next_track_idx

	
