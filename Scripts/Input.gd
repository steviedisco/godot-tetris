extends Node2D

signal MoveLeft
signal MoveRight
signal RotateLeft
signal RotateRight
signal Drop
signal DropStopped

var _input_move_ready = true
var _dropping = false


func _ready():
	reset_Timers()
		
	
func _process(_delta):
	if !_dropping and Input.is_action_pressed("ui_down"):	
		_dropping = true
		emit_signal("Drop")
	elif _dropping and !Input.is_action_pressed("ui_down"):
		_dropping = false
		emit_signal("DropStopped")
	
	if _input_move_ready:
		if Input.is_action_pressed("ui_left"):	
			emit_signal("MoveLeft")
			_input_move_ready = false
			
		if Input.is_action_pressed("ui_right"):	
			emit_signal("MoveRight")
			_input_move_ready = false
	
		if Input.is_action_pressed("ui_rotate_left"):	
			emit_signal("RotateLeft")
			_input_move_ready = false
			
		if Input.is_action_pressed("ui_rotate_right"):	
			emit_signal("RotateRight")
			_input_move_ready = false


func _on_InputTimer_timeout():
	_input_move_ready = true


func stop_drop():
	emit_signal("DropStopped")


func reset_Timers():
	$InputTimer.start()
