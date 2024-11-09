extends StaticBody3D

@onready var anim = $AnimationPlayer
var char = null

func interact(c):
	char = c
	set_collision_layer_value(2, false)
	anim.play("Open")

func destroy():
	pass

func allow_pickup():
	set_collision_layer_value(2, true)

func _on_animation_player_animation_finished(anim_name):
	if char != null:
		char.give_shotgun()
