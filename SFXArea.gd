extends Area3D

@onready var sfx = $AudioStreamPlayer3D

func _on_body_entered(body):
	sfx.play()
	set_collision_mask_value(2, false)
