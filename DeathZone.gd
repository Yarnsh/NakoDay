extends Area3D

@export var death_text = ";_;"
@export var sound : AudioStream
@export var db = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(kill)

func kill(body):
	if body is CharacterBody3D:
		body.kill(death_text, sound, db)
