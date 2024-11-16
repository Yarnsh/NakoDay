extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_image(path):
	var img = Image.new()
	img.load(path)
	var t = ImageTexture.create_from_image(img)
	texture = t
