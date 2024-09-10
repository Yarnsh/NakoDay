extends SubViewport

func _ready():
	get_tree().root.size_changed.connect(res_changed)
	res_changed()

func res_changed():
	size = get_tree().root.size
