extends PanelContainer

func _ready():
	check_photos_available()

func check_photos_available():
	var dir = DirAccess.open("user://camera")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if file_name.ends_with(".jpg"):
					show() # We have some photos, show this button and warning
					return
