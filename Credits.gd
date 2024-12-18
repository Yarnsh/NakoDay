extends PanelContainer

@export var pic_prefab : PackedScene

@onready var credits = $Node/Credits
@onready var poloroids = $Poloroids
@onready var sides = [$Poloroids/Side1, $Poloroids/Side2, $Poloroids/Side3, $Poloroids/Side4]
@onready var music = $AudioStreamPlayer
@onready var fast_music = $AudioStreamPlayer2
var moving = false
var side = 0
var is_fast = false

@onready var main_scene = $"../.."

func _process(delta):
	if moving:
		if is_fast:
			credits.global_position.y -= 150.0 * delta
		else:
			credits.global_position.y -= 30.0 * delta
		poloroids.global_position = Vector2(size.x * 0.5, credits.global_position.y)
		
		if credits.global_position.y + credits.size.y <= 0.0:
			moving = false
			poloroids.hide()
			main_scene.set_mode(1)
			main_scene.main.photos.check_photos_available()
		
		poloroids.visible = visible

func start_credits(fast):
	is_fast = fast
	credits.global_position.y = size.y + 80
	
	sides[0].position.x = size.x * 0.35
	sides[1].position.x = size.x * -0.35
	sides[2].position.x = size.x * 0.25
	sides[3].position.x = size.x * -0.25
	
	if !is_fast:
		var count = 0
		var cdir = DirAccess.open("user://camera")
		if cdir:
			cdir.list_dir_begin()
			var file_name = cdir.get_next()
			while file_name != "":
				if !cdir.current_is_dir():
					if file_name.ends_with(".jpg"):
						count += 1
				file_name = cdir.get_next()
		
		var dir = DirAccess.open("user://camera")
		var i = 0
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if !dir.current_is_dir():
					if file_name.ends_with(".jpg"):
						var new_pic = pic_prefab.instantiate()
						sides[side].add_child(new_pic)
						new_pic.set_image("user://camera/" + file_name)
						new_pic.scale = Vector2.ONE * 0.25
						new_pic.position = Vector2(0, i * (credits.size.y / count))
						new_pic.rotation = randf_range(-0.25, 0.25)
						
						i += 1
						side = (side + 1) % len(sides)
				file_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path.")
	
	moving = true
	if !is_fast:
		music.play()
	else:
		fast_music.play()

func _on_visibility_changed():
	credits.visible = visible
