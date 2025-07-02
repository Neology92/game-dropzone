class_name Block extends Node2D


var row: int = 0



func move_down(height: int, rows: int) -> void:
	row += 1
	if row >= rows:
		queue_free()
	else:
		position.y = row * height


func _on_body_shape_entered(_body_rid:RID, _body:Node2D, _body_shape_index:int, _local_shape_index:int) -> void:
	if _body is Player:
		_body.kill()  # Call the player's kill method
