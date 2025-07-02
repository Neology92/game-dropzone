class_name Track extends Node2D

const block_height: int = 108
const blocks_in_col: int = 6

@export var player_slot: Node2D

var block_preset: PackedScene = preload("res://scenes/block.tscn")

var index: int = 0


func _init() -> void:
	GameManager.instance.tracks.append(self)
	index = GameManager.instance.tracks.size() - 1


func _ready() -> void:
	player_slot.position = Vector2(0, (blocks_in_col - 2) * block_height)


func move_blocks_down() -> void:
	# Move all blocks down by one row
	for b in get_children():
		if b is Block:
			b.animate_bump()
			b.move_down(block_height, blocks_in_col)

func add_block(_image: Resource) -> void:
	var block = block_preset.instantiate()
	block.img_resource = _image
	add_child(block)
