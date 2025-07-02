class_name Block extends Node2D


@onready var image: Sprite2D = %Image
var img_resource: Resource
var row: int = 0
var _default_image_scale: Vector2 = Vector2.ONE
var bump_scale: float = 1.05


func _ready() -> void:
	self.connect("ready", _on_ready)

func _on_ready() -> void:
	_default_image_scale = image.scale
	animate_bump()
	if img_resource:
		image.texture = img_resource

func move_down(height: int, rows: int) -> void:
	row += 1
	if row >= rows:
		queue_free()
	else:
		var next_position = position
		next_position.y = row * height
		animate_move(next_position)


func _on_body_shape_entered(_body_rid:RID, _body:Node2D, _body_shape_index:int, _local_shape_index:int) -> void:
	if _body is Player:
		_body.kill()  # Call the player's kill method


func animate_move(_target_pos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", _target_pos, 0.05)
	tween.set_ease(Tween.EASE_IN_OUT)


func animate_bump() -> void:
	if ready:
		scale = _default_image_scale * bump_scale
		await get_tree().create_timer(0.1).timeout
		scale = _default_image_scale
