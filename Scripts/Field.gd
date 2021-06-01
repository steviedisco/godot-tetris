extends Node2D

var BLOCK_SIZE = 10
var COLS = 10
var ROWS = 20

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
	var velocity = Vector2(0.0, 4 * BLOCK_SIZE)
	var any_collide = false
	
	for block in _current_shape.get_children():
		var collide = block.move_and_collide(velocity)
	
		if collide:
			any_collide = true

	if any_collide:
		place_shape()
		new_shape()


func new_shape():
	$ShapeGenerator.new_shape()
	
	clear_children($CurrentShape)
	_current_shape = $ShapeGenerator.CurrentShape

	$CurrentShape.position.x = 20 * BLOCK_SIZE
	
	if "StartOffset" in _current_shape:
		$CurrentShape.position.y = 4 * _current_shape.StartOffset
	else:
		$CurrentShape.position.y = 4 * BLOCK_SIZE

	$CurrentShape.add_child(_current_shape)


func place_shape():
	var dupe = _current_shape.duplicate(true)
	
	dupe.position.x = $CurrentShape.position.x
	dupe.position.y = $CurrentShape.position.y
	
	for child in dupe.get_children():
		dupe.remove_child(child)
	
	for block in _current_shape.get_children():
		var dupe_block = block.duplicate(true)
		dupe_block.set_collision_layer_bit(0, false)
		dupe_block.set_collision_layer_bit(1, true)
		dupe_block.set_collision_mask_bit(0, true)
		dupe.add_child(dupe_block)
	
	$PlacedShapes.add_child(dupe)
