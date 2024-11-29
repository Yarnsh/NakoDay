extends Node3D

@export var game_prefab : PackedScene
@onready var game_scene = $GameScene

@onready var main = $Menus/Main
@onready var settings = $Menus/Settings
@onready var controls = $Menus/Controls
@onready var death = $Menus/DeathScene
@onready var credits = $Menus/Credits

var mode = 1

func _ready():
	Global.main = self
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_window().grab_focus()

func stop_game():
	if game_scene != null:
		remove_child(game_scene)
		game_scene.free()

func back_to_checkpoint():
	if game_scene == null:
		start_game()
	else:
		start_game()
	set_mode(0)

func resume():
	if game_scene == null:
		start_game()
	set_mode(0)

func start_game():
	stop_game()
	AudioServer.set_bus_effect_enabled(1, 0, false)
	
	game_scene = game_prefab.instantiate()
	add_child(game_scene)
	game_scene.create_player()

func get_fov():
	return settings.fov.value

func get_mouse_sensitivity():
	return settings.mouse_sensitivity.value

func set_mode(new_mode):
	mode = new_mode
	
	if mode == 0:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	
	main.hide()
	settings.hide()
	controls.hide()
	death.hide()
	credits.hide()
	# mode 0 is no menus open, the actual game
	if mode == 1:
		main.show()
	elif mode == 2:
		settings.show()
	elif mode == 3:
		controls.show()
	elif mode == 4:
		death.show()
	elif mode == 5:
		credits.show()

func _input(event):
	if event.is_action_pressed("menu"):
		if mode == 0:
			set_mode(1)
		elif mode == 1:
			set_mode(0)
		elif mode == 2:
			set_mode(1)
		elif mode == 3:
			set_mode(2)

func show_death(description, sound, db):
	call_deferred("stop_game")
	death.start_death(description, sound, db)
	set_mode(4)

func show_credits(fast = false):
	call_deferred("stop_game")
	credits.start_credits(fast)
	set_mode(5)
