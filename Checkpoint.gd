extends Area3D

@onready var game_scene = $"../.."

func _on_body_entered(body):
	print(body)
	game_scene.update_player_stuff()
	set_deferred("monitoring", false)
