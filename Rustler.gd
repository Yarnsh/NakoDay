extends Area3D

func _on_body_entered(body):
	body.rustle_movement = true

func _on_body_exited(body):
	body.rustle_movement = false
