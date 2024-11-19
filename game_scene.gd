extends Node3D

@export var player_prefab : PackedScene

func create_player():
	var ps = player_prefab.instantiate()
	add_child(ps)
	ps.global_position = Vector3(0.0, -4.297, -2.503)
