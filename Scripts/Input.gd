extends Node2D

signal MoveLeft
signal MoveRight
signal RotateLeft
signal RotateRight
signal Drop
signal DropStopped
signal Store
signal Retrieve

var _input_move_ready = true
var _input_rotate_ready = true
var _dropping = false

func _ready():
	$MoveTimer.start()
	$RotateTimer.start()
	pass
	
	
func _process(_delta):
	if Input.is_action_pressed("ui_down"):	
		_dropping = true
		emit_signal("Drop")
	elif _dropping:
		_dropping = false
		emit_signal("DropStopped")
	
	if _input_move_ready:
		if Input.is_action_pressed("ui_left"):	
			emit_signal("MoveLeft")
			_input_move_ready = false
			
		if Input.is_action_pressed("ui_right"):	
			emit_signal("MoveRight")
			_input_move_ready = false
	
	if _input_rotate_ready:
		if Input.is_action_pressed("ui_rotate_left"):	
			emit_signal("RotateLeft")
			_input_rotate_ready = false
			
		if Input.is_action_pressed("ui_rotate_right"):	
			emit_signal("RotateRight")
			_input_rotate_ready = false


func _on_MoveTimer_timeout():
	_input_move_ready = true


func _on_RotateTimer_timeout():
	_input_rotate_ready = true
