extends TextureRect

func _ready():
	get_tree().root.size_changed.connect(res_changed)
	res_changed()

func res_changed():
	anchors_preset = PRESET_FULL_RECT
