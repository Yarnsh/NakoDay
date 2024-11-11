extends StaticBody3D

@onready var anim = $AnimationPlayer
@onready var sound = $AudioStreamPlayer3D
var char = null

func interact(c):
	char = c
	set_collision_layer_value(2, false)
	anim.play("Open")
	sound.play()

func destroy():
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, false)
	$Top.hide()
	$Bottom.hide()
	# TODO: some paper particles or something

func allow_pickup():
	set_collision_layer_value(2, true)

func _on_animation_player_animation_finished(anim_name):
	if char != null:
		char.give_shotgun()
