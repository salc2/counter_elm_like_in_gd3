extends Node
class_name CustomState

var _player_velocity: Vector2 = Vector2(0, 0)
var _fps: float = 0

func _init(player_velocity: Vector2,fps:float):
	_player_velocity = player_velocity
	_fps = fps
	
