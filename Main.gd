extends PanelContainer

@onready var main_scene = $"../.."
@onready var resume_button = $VBoxContainer/VBoxContainer/Continue

func new_game():
	main_scene.start_game({})
	main_scene.set_mode(0)

func resume():
	main_scene.resume()

func settings():
	main_scene.set_mode(2)

func quit():
	get_tree().quit()
