extends Node2D

var BLOCK_SIZE = 10
var COLS = 10
var ROWS = 20
var DROP_SPEED = 0.1

var _screen_size
var _field_blocks = []

var _current_shape

func _ready():
	_screen_size = get_viewport_rect().size
	
	for _i in range(ROWS):
		var col = []
		for _j in range(COLS):
			col.append(0)
		_field_blocks.append(col)
	
	new_shape()


func clear_children(node):
	for child in node.get_children():
		node.remove_child(child)


func _on_ShapeGenerator_shape_drop():
	if !try_move(0.0, 4 * BLOCK_SIZE):
		place_shape()
		new_shape()
		$ShapeGenerator.reset_DropTimer()


func new_shape():
	$ShapeGenerator.new_shape()
	
	clear_children($CurrentShape)
	_current_shape = $ShapeGenerator.CurrentShape.duplicate()
	$CurrentShape.add_child(_current_shape)

	$CurrentShape.position.x = 20 * BLOCK_SIZE
	$CurrentShape.position.y = 4 * BLOCK_SIZE


func place_shape():
	var placed = _current_shape.duplicate(true)
	placed.position = Vector2($CurrentShape.position)
	clear_children(placed)
	
	for block in _current_shape.get_children():
		var dupe = block.duplicate()
		dupe.set_collision_layer_bit(0, false)
		dupe.set_collision_layer_bit(1, true)
		dupe.set_collision_mask_bit(0, true)
		dupe.set_collision_mask_bit(1, false)
		placed.add_child(dupe)

	$PlacedShapes.add_child(placed)
	clear_children($CurrentShape)


func _on_Input_MoveLeft():
	try_move(4 * -BLOCK_SIZE, 0.0)


func _on_Input_MoveRight():
	try_move(4 * BLOCK_SIZE, 0.0)


func _on_Input_Drop():
	$ShapeGenerator.set_DropTimer(DROP_SPEED)


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



