extends Button

@onready var popup = $"../../../../PopupPanel"
@export var action : StringName

func _ready():
	update_from_current()

func _on_pressed():
	popup.popup(self)

func update_from_current():
	text = InputMap.action_get_events(action)[0].as_text()
