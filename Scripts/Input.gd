extends Node2D
	
signal MoveLeft
signal MoveRight
signal RotateLeft
signal RotateRight
signal Drop
signal Store
signal Retrieve

var _input_ready = true

func _ready():
	$InputTimer.start()
	pass
	
	
func _process(_delta):
	if !_input_ready:
		return
	
	if Input.is_action_pressed("ui_left"):	
		emit_signal("MoveLeft")
		_input_ready = false
	if Input.is_action_pressed("ui_right"):	
		emit_signal("MoveRight")
		_input_ready = false

func _on_InputTimer_timeout():
	_input_ready = true
