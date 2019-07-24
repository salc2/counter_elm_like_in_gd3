extends KinematicBody2D

func _move_and_slide(velocity: Vector2) -> Vector2:
	return move_and_slide(velocity, Vector2(0, -1))
