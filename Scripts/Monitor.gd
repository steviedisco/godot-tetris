extends RayCast2D


func CheckLines(mode = "remove", start_row = 19):

	for row_index in range (start_row, 0, -1):
		
		clear_exceptions()
		
		position.y = (row_index * 40) + 20

		var collision_count = 0
		var colliders = []

		for _col in range(10):  
			force_raycast_update()
			
			if is_colliding():
				collision_count += 1
				
				var collider = get_collider()
				add_exception(collider)
				colliders.push_back(collider)
			
			elif mode == "remove":
				break

		if mode == "remove" and collision_count == 10:
			for collider in colliders:
				var parent = collider.get_parent()
				collider.queue_free()
				parent.remove_child(collider)
				
				
				if (parent.get_child_count() == 0):
					parent.queue_free()
					parent.get_parent().remove_child(parent)

			CheckLines("shift", row_index - 1)
			
		elif mode == "shift":
			for collider in colliders:
				collider.global_position.y += 40
