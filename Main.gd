extends PanelContainer

@onready var main_scene = $"../.."
@onready var resume_button = $VBoxContainer/VBoxContainer/Resume

func new_game():
	main_scene.start_game()
	main_scene.set_mode(0)
	resume_button.show()

func resume():
	main_scene.resume()

func settings():
	main_scene.set_mode(2)

func quit():
	get_tree().quit()
