extends Node3D

@export var pellet_count = 8
@export var spread = 0.5
var mask = 0b0101

func shoot():
	for i in range(pellet_count):
		var space_state = get_world_3d().direct_space_state
		var target_dir = -global_basis.z.rotated(global_basis.x, randf_range(0.0, spread)).rotated(global_basis.z, randf_range(0.0, 2.0*PI))
		var target_position = global_position + (target_dir * 1000.0)
		print(target_position)
		var query = PhysicsRayQueryParameters3D.create(global_position, target_position,
			mask, [])
		var result = space_state.intersect_ray(query)
		
		if result != null and result["collider"] != null:
			print(result["collider"].name)
			if result["collider"].has_method("destroy"):
				result["collider"].destroy()
			# TODO: make effects at the collision points
