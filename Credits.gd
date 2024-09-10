extends PanelContainer

@onready var credits = $Node/Credits
var moving = false

func _process(delta):
	if moving:
		credits.global_position.y -= 50.0 * delta
		
		if credits.global_position.y + credits.size.y <= 0.0: # TODO: this is getting us the wrong value somehow?
			get_tree().quit()

func start_credits():
	moving = true
	credits.global_position.y = get_tree().root.size.y / ProjectSettings.get_setting("display/window/stretch/scale")

func _on_visibility_changed():
	credits.visible = visible
