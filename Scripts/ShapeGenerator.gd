extends Node

signal shape_drop

export var ShapePath = "res://Scenes/Shapes"

onready var CurrentShape
onready var NextShape

onready var _shapes = []
onready var _shape_queue = []

func _ready():
	randomize()

	load_shapes(ShapePath)
	generate_queue()
	
	$DropTimer.start()


func load_shapes(path):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			_shapes.push_back(load(path + "/" + file))

	dir.list_dir_end()


func generate_queue():
	for _number in range(2):
		_shape_queue.push_back(get_next_shape_instance())
		
	set_shapes()


func get_next_shape_instance(): 
	return _shapes[randi() % _shapes.size()].instance()


func set_shapes():
	CurrentShape = _shape_queue[0]
	NextShape = _shape_queue[1]


func _on_DropTimer_timeout():
	emit_signal("shape_drop")
	

func new_shape():
	_shape_queue.push_back(get_next_shape_instance())
	_shape_queue.pop_front()
	set_shapes()	
