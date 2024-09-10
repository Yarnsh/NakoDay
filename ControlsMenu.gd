extends PanelContainer

@onready var main_scene = $"../.."
@onready var control_parent = $All/Options/Controls

var actions_list = [
	"interact",
	"Use_Nail",
	"left",
	"right",
	"forward",
	"back",
	"menu"
]

var default = {
	"interact": InputEventKey.new(),
	"Use_Nail": InputEventMouseButton.new(),
	"left": InputEventKey.new(),
	"right": InputEventKey.new(),
	"forward": InputEventKey.new(),
	"back": InputEventKey.new(),
	"menu": InputEventKey.new()
}

func _ready():
	default["interact"].keycode = 69
	default["Use_Nail"].button_index = 2
	default["left"].keycode = 65
	default["right"].keycode = 68
	default["forward"].keycode = 87
	default["back"].keycode = 83
	default["menu"].keycode = 4194305
	
	var loaded = load_keymap()
	set_from_keymap(loaded)

func load_keymap():
	if not FileAccess.file_exists("user://keys.dat"):
		save_keymap(default)
		return default

	var file := FileAccess.open("user://keys.dat", FileAccess.READ)
	var temp_keymap: Dictionary = file.get_var(true)
	file.close()
	
	return temp_keymap

func save_keymap(keymap):
	var file := FileAccess.open("user://keys.dat", FileAccess.WRITE)
	file.store_var(keymap, true)
	file.close()

func get_current_keymap():
	var keymap = {}
	for action in actions_list:
		keymap[action] = InputMap.action_get_events(action)[0]
	return keymap

func set_from_keymap(keymap):
	var default = get_current_keymap() # TODO: change once we have a default
	for button in control_parent.get_children():
		var event = keymap.get(button.action, default[button.action])
		InputMap.action_erase_events(button.action)
		InputMap.action_add_event(button.action, event)
		button.text = event.as_text()

func reset():
	set_from_keymap(default)
	save_keymap(default)

func back():
	main_scene.set_mode(2)
