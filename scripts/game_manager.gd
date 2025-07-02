extends Node

var instance: GameManager

var music_player: AudioStreamPlayer2D = preload("res://scenes/music_player.tscn").instantiate()

var block_images: Array = []
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

	music_player.bus = "music"  # Ensure this matches your audio bus setup
	add_child(music_player)
	add_child(game_timer)
	load_block_textures()

func _ready() -> void:
	player.position = Vector2(9999, 9999)
	get_tree().current_scene.add_child(player)
	current_track_idx = randi() % tracks.size()
	
	self.connect("ready", _on_ready)


func _on_ready() -> void:
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
			var image = block_images.pick_random()
			tracks[i].add_block(image)
	
	current_track_idx = next_track_idx

	

func load_block_textures() -> void:
	var blocks_dir = DirAccess.open("res://assets/blocks")
	if blocks_dir:
		var files = blocks_dir.get_files()
		for file in files:
			if file.ends_with("square.png"):
				var img = load("res://assets/blocks/" + file)
				img.set("width", 108)
				block_images.append(img)
