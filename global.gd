extends Node

var now = 0
const debug = false

var camera_screenshots = true
var main : Node
var player : CharacterBody3D

var scare_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	now = Time.get_ticks_msec()
