extends Node2D

var BLOCK_SIZE = 10
var COLS = 10
var ROWS = 20
var DROP_SPEED = 0.1

var _screen_size

var _current_shape
var _current_shape_dir = 1

func _ready():
	_screen_size = get_viewport_rect().size

	new_shape()


func clear_children(node):
	for child in node.get_children():
		node.remove_child(child)


func _on_ShapeGenerator_shape_drop():
	if !try_move(0.0, 4 * BLOCK_SIZE):
		place_shape()
		new_shape()


func new_shape():
	$ShapeGenerator.new_shape()
	$Input.stop_drop()
	$Input.reset_Timers()
	
	clear_children($CurrentShape)
	
	_current_shape = $ShapeGenerator.CurrentShape.duplicate()
	_current_shape_dir = 1

	$CurrentShape.add_child(_current_shape)

	$CurrentShape.position.x = 20 * BLOCK_SIZE
	$CurrentShape.position.y = 4 * BLOCK_SIZE
	$CurrentShape.rotation = 0
	
	for block in _current_shape.get_children():
		block.rotation = 0


func place_shape():
	var placed = _current_shape.duplicate()
	placed.position = Vector2($CurrentShape.position + _current_shape.position)
	placed.rotation = _current_shape.rotation
	clear_children(placed)
	
	for block in _current_shape.get_children():
		var dupe = block.duplicate()
		dupe.set_collision_layer_bit(0, false)
		dupe.set_collision_layer_bit(1, true)
		dupe.set_collision_mask_bit(0, true)
		dupe.set_collision_mask_bit(1, false)
		placed.add_child(dupe)

	$PlacedShapes.add_child(placed)
	$Monitor.CheckLines()
	
	clear_children($CurrentShape)


func _on_Input_MoveLeft():
	try_move(4 * -BLOCK_SIZE, 0.0)


func _on_Input_MoveRight():
	try_move(4 * BLOCK_SIZE, 0.0)


func _on_Input_Drop():
	$ShapeGenerator.set_DropTimer(DROP_SPEED)
	$ShapeGenerator.start_DropTimer()


func _on_Input_DropStopped():
	$ShapeGenerator.reset_DropTimer()


func try_move(x, y) -> bool:
	
	var prev_pos = Vector2($CurrentShape.position)
	var collide = false
	
	$CurrentShape.position += Vector2(x, y)
	
	for block in _current_shape.get_children():
		if block.test_move(block.get_global_transform(), Vector2.ZERO):
			collide = true
			$CurrentShape.position = Vector2(prev_pos)
			break
			
	return !collide


func try_rotate(dir: int) -> bool:
	
	var prev_rot = _current_shape.rotation
	var collide = false
	
	_current_shape.rotation += dir * PI/2
	
	for block in _current_shape.get_children():
		if block.test_move(block.get_global_transform(), Vector2.ZERO):
			collide = true
			_current_shape.rotation = prev_rot
			break
	
	if !collide:
		for block in _current_shape.get_children():
			block.rotation -= dir * PI/2
			
		_current_shape_dir += dir

		if _current_shape_dir < 1:
			_current_shape_dir = 4
		elif _current_shape_dir > 4:
			_current_shape_dir = 1
	
	return !collide


func _on_Input_RotateLeft():
	if _current_shape.Directions != 4:
		var dir = _current_shape.Directions - _current_shape_dir
		if dir > 0:
			try_rotate(-1)
		else:
			try_rotate(1)
	else:
		try_rotate(-1)


func _on_Input_RotateRight():
	if _current_shape.Directions != 4:
		var dir = _current_shape.Directions - _current_shape_dir
		if dir > 0:
			try_rotate(1)
		else:
			try_rotate(-1)
	else:
		try_rotate(1)
