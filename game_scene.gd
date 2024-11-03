extends Node3D

@export var player_prefab : PackedScene

func create_player():
	var ps = player_prefab.instantiate()
	add_child(ps)
