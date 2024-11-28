extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	var f = InputMap.action_get_events("forward")[0].as_text()
	var l = InputMap.action_get_events("left")[0].as_text()
	var d = InputMap.action_get_events("back")[0].as_text()
	var r = InputMap.action_get_events("right")[0].as_text()
	text = "[center]Move:\n" + f + "\n" + l + " " + d + " " + r + "[/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
