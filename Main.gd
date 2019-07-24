extends CanvasLayer
signal internal_events

var player_vel: CustomState = null


export var GRAVITY: float = 200.0
export var WALK_SPEED: int = 200
export var JUMP_SPEED: int = 500

const CustomState = preload("res://CustomState.gd")
const CustomInputEvent = preload("res://CustomInputEvent.gd")

func _ready():
	player_vel = CustomState.new(Vector2(0,0),0)

func _process(delta):
	var e := CustomInputEvent.new(delta)
	e.action = "delta"
	emit_signal("internal_events",e)

func handle_events(event: CustomInputEvent) -> void:
	player_vel = update(player_vel,event)
	view(player_vel)

func update(state:CustomState,event: CustomInputEvent) -> CustomState:
	if(event.action == "pressed_up"):
		if(state._player_velocity.y == 0.0):
			state._player_velocity.y -= JUMP_SPEED
		var ns = $Player._move_and_slide(state._player_velocity)
		return CustomState.new(ns, 0)
	elif(event.action == "pressed_right"):
		state._player_velocity.x = WALK_SPEED
		var ns = $Player._move_and_slide(state._player_velocity)
		return CustomState.new(ns, 0)
	elif(event.action == "released_right"):
		state._player_velocity.x = 0
		var ns = $Player._move_and_slide(state._player_velocity)
		return CustomState.new(ns, 0)
	elif(event.action == "pressed_left"):
		state._player_velocity.x = -WALK_SPEED
		var ns = $Player._move_and_slide(state._player_velocity)
		return CustomState.new(ns, 0)
	elif(event.action == "released_left"):
		state._player_velocity.x = 0
		var ns = $Player._move_and_slide(state._player_velocity)
		return CustomState.new(ns, 0)
	elif(event.action == "delta"):
		state._player_velocity.y += (event._delta * GRAVITY * 3)
		var ns = $Player._move_and_slide(state._player_velocity)
		return CustomState.new(ns, 1/event._delta)
	else:
		return state
	
func view(state: CustomState) -> void:
	$FPS.set_fps(state._fps)
	
func _unhandled_input(event: InputEvent):
	var e := CustomInputEvent.new(0)
	if(event is InputEventKey and event.scancode == KEY_UP):
			if(event.is_pressed()):
				e.action = "pressed_up"
			else:
				e.action = "released_up"
			emit_signal("internal_events",e)
	if(event is InputEventKey and event.scancode == KEY_RIGHT):
			if(event.is_pressed()):
				e.action = "pressed_right"
			else:
				e.action = "released_right"
			emit_signal("internal_events",e)
	if(event is InputEventKey and event.scancode == KEY_LEFT):
			if(event.is_pressed()):
				e.action = "pressed_left"
			else:
				e.action = "released_left"
			emit_signal("internal_events",e)

func _exit_tree():
	player_vel.free()
