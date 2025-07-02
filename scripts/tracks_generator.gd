extends Node2D

const track_width: int = 108
const screen_width: int = 1152

var track_scene: PackedScene = preload("res://scenes/track.tscn")


func _init() -> void:
    @warning_ignore("integer_division")
    var tracks_number: int = screen_width / track_width
    var tracks_spacing: int = (screen_width - (tracks_number * track_width)) / (tracks_number + 1)

    var current_x :int = 0

    while current_x < screen_width - track_width:
        var track = track_scene.instantiate()
        track.position.x = current_x + tracks_spacing
        add_child(track)
        current_x += track_width + tracks_spacing


func clear_children() -> void:
    for child in get_children():
        if child is Track:
            child.queue_free()
