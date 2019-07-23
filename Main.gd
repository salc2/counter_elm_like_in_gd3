extends CanvasLayer
signal internal_events

var value: CustomState = CustomState.new(0,0)

const CustomState = preload("res://CustomState.gd")
const CustomInputEvent = preload("res://CustomInputEvent.gd")

func _process(delta):
	var e := CustomInputEvent.new(delta)
	e.action = "delta"
	emit_signal("internal_events",e)

func handle_events(event: CustomInputEvent) -> void:
	value = update(value,event)
	view(value)

func update(state:CustomState,event: CustomInputEvent) -> CustomState:
	if(event.action == "increment"):
		return CustomState.new(state._value + 1, 0)
	elif(event.action == "decrement"):
		return CustomState.new(state._value - 1, 0)
	elif(event.action == "delta"):
		return CustomState.new(state._value, 1/event._delta)
	else:
		return state
	
func view(state: CustomState) -> void:
	$Counter.text = str(state._value)
	$FPS.set_fps(state._fps)

func _on_Decrement_pressed():
	var e := CustomInputEvent.new(0)
	e.action = "decrement"
	emit_signal("internal_events",e)


func _on_Increment_pressed():
	var e := CustomInputEvent.new(0)
	e.action = "increment"
	emit_signal("internal_events",e)
	
func _unhandled_input(event: InputEvent):
	if(event is InputEventKey and event.is_pressed()):
		if(event.scancode == KEY_UP):
			var e := CustomInputEvent.new(0)
			e.action = "increment"
			emit_signal("internal_events",e)
		if(event.scancode == KEY_DOWN):
			var e := CustomInputEvent.new(0)
			e.action = "decrement"
			emit_signal("internal_events",e)
