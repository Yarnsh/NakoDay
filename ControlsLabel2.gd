extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = InputMap.action_get_events("Action")[0].as_text()
	text = "[center]Take Photo:\n" + a + "[/center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
