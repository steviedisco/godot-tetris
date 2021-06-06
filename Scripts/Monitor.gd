extends RayCast2D

var _screen_size

func _ready():
	_screen_size = get_viewport_rect().size


func _draw():
	draw_line(position, cast_to, Color(255, 0, 0), 1)


func CheckLines():

	for row_index in range (19, 18, -1):
		
		clear_exceptions()
		
		position.y = (row_index * 40) + 20
		cast_to = Vector2(_screen_size.x - 20, position.y)

		var collision_count = 0
		var colliders = []

		for col in range(10):  
			force_raycast_update()
			
			if is_colliding():
				collision_count += 1
			else:
				break

			var collider = get_collider()
			add_exception(collider)
			colliders.push_back(collider)

		if collision_count > 0:
			print("colliding = {count}".format({"count": collision_count}))

		if collision_count == 10:
			for index in range(10):
				var node = colliders[index]
				node.visible = false
