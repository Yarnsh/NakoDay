extends Area3D

@onready var cake = $"../Cake"
@onready var present = $"../present"
@onready var door = $"../DestroyableBars"

@onready var c1 = $"../ExtraCandles/Candle"
@onready var c2 = $"../ExtraCandles/Candle2"
@onready var c3 = $"../ExtraCandles/Candle3"
@onready var c4 = $"../ExtraCandles/Candle4"
@onready var p1 = $"../GPUParticles3D"
@onready var p2 = $"../GPUParticles3D2"

@onready var pop = $"../Pop"
@onready var horn = $"../Horn"

var prepare = false
var wait_time = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if prepare:
		wait_time -= delta
		if wait_time <= 0.0:
			prepare = false
			cake.light()
			c1.light()
			c2.light()
			c3.light()
			c4.light()
			p1.emitting = true
			p2.emitting = true
			pop.play()
			horn.play()
			present.allow_pickup()


func _on_body_entered(body):
	body.stop_scary_music()
	Global.scare_done = true
	set_collision_mask_value(32, false)
	door.close()
	prepare = true
