extends Node2D

const track_width: int = 108
const screen_width: int = 1152

var track_scene: PackedScene = preload("res://scenes/track.tscn")


func _init() -> void:
    @warning_ignore("integer_division")
    var spacing :int = (screen_width % track_width) / 2
    var current_x :int = 0

    while current_x < screen_width - track_width:
        var track = track_scene.instantiate()
        track.position.x = spacing + current_x
        add_child(track)
        current_x += track_width


func clear_children() -> void:
    for child in get_children():
        if child is Track:
            child.queue_free()
