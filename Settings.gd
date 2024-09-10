extends PanelContainer

signal fov_changed(fov)

@onready var main_scene = $"../.."

@onready var fullscreen = $All/Options/Controls/Fullscreen
@onready var resolution_x = $All/Options/Controls/Resolution/X
@onready var resolution_y = $All/Options/Controls/Resolution/Y
@onready var fov = $All/Options/Controls/FoV

@onready var master_volume = $All/Options/Controls/MasterVolume
@onready var sfx_volume = $All/Options/Controls/SFXVolume
@onready var ambient_volume = $All/Options/Controls/AmbientVolume

@onready var apply_button = $All/Buttons/Apply

var last_settings = {}

func _ready():
	set_settings_from_dict(read_from_file())
	apply_current_settings()
	apply_button.disabled = true

func get_current_settings_dict():
	return {
		"fullscreen": fullscreen.button_pressed,
		"resolution_x": resolution_x.value,
		"resolution_y": resolution_y.value,
		"fov": fov.value,
		"master_volume": master_volume.value,
		"sfx_volume": sfx_volume.value,
		"ambient_volume": ambient_volume.value
	}

func set_settings_from_dict(settings):
	fullscreen.button_pressed = settings.get("fullscreen", true)
	resolution_x.editable = !fullscreen.button_pressed
	resolution_y.editable = !fullscreen.button_pressed
	resolution_x.value = settings.get("resolution_x", 1920)
	resolution_y.value = settings.get("resolution_y", 1080)
	fov.value = settings.get("fov", 90)
	master_volume.value = settings.get("master_volume", 100)
	sfx_volume.value = settings.get("sfx_volume", 100)
	ambient_volume.value = settings.get("ambient_volume", 100)

func apply_current_settings():
	if fullscreen.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(resolution_x.value, resolution_y.value))
	
	fov_changed.emit(fov.value)
	
	AudioServer.set_bus_volume_db(0, linear_to_db(float(master_volume.value)/100.0))
	AudioServer.set_bus_volume_db(1, linear_to_db(float(sfx_volume.value)/100.0))
	AudioServer.set_bus_volume_db(2, linear_to_db(float(ambient_volume.value)/100.0))

func _on_apply_pressed():
	last_settings = get_current_settings_dict()
	apply_current_settings()
	apply_button.disabled = true
	write_to_file(last_settings)

func _on_cancel_pressed():
	set_settings_from_dict(last_settings)
	apply_button.disabled = true
	main_scene.set_mode(1)

func _on_change(value):
	apply_button.disabled = false
	resolution_x.editable = !fullscreen.button_pressed
	resolution_y.editable = !fullscreen.button_pressed

func write_to_file(settings):
	var text = JSON.stringify(settings)
	var file = FileAccess.open("user://settings.dat", FileAccess.WRITE)
	file.store_string(text)

func read_from_file():
	var file = FileAccess.open("user://settings.dat", FileAccess.READ)
	if file == null:
		return {}
	var content = file.get_as_text()
	var result = JSON.parse_string(content)
	if result == null:
		return {}
	return result

func back():
	main_scene.set_mode(1)

func _on_controls_pressed():
	main_scene.set_mode(3)

func _input(event):
	if event.is_action_pressed("change_windowed"):
		fullscreen.button_pressed = !fullscreen.button_pressed
		_on_apply_pressed()
