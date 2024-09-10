extends Node3D

@onready var main_scene = $".."

@onready var player_pos = ($Character).global_position
@onready var cam_rot = ($Character/RootCam).global_rotation

@onready var character = $Character
@onready var cam = $Character/RootCam

func update_player_stuff():
	player_pos = ($Character).global_position
	cam_rot = ($Character/RootCam).global_rotation
	
	# a reasonable enough place to save to file
	main_scene.save_flags(get_flags())

func apply_flags(flags):
	player_pos = flags.get("player_pos", player_pos)
	character.global_position = player_pos
	cam_rot = flags.get("cam_rot", cam_rot)
	cam.set_grot(cam_rot)

func get_flags():
	return {
		"player_pos": player_pos,
		"cam_rot": cam_rot
	}
