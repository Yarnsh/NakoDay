extends PanelContainer

@onready var menu = $".."
@onready var label = $Label
var last_button = null

func popup(button):
	last_button = button
	label.text = "Press button for '" + button.name + "'"
	show()

func _input(event):
	if last_button != null and (event is InputEventKey or event is InputEventMouseButton):
		InputMap.action_erase_events(last_button.action)
		InputMap.action_add_event(last_button.action, event)
		last_button.text = event.as_text()
		last_button = null
		hide()
		menu.save_keymap(menu.get_current_keymap())
