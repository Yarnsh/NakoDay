extends PanelContainer

@onready var main_scene = $"../.."

@onready var death_sound = $DeathSound
@onready var dead_label = $VBoxContainer/Label
@onready var description_label = $VBoxContainer/Description
@onready var button1 = $VBoxContainer/Continue
@onready var button2 = $VBoxContainer/Menu

var show_start = 0

func start_death(description, sound, db):
	hide_all()
	if sound != null:
		death_sound.volume_db = db
		death_sound.stream = sound
		death_sound.play()
	description_label.text = description
	show_start = float(Time.get_ticks_msec()) / 1000.0

func hide_all():
	dead_label.modulate = Color.BLACK
	description_label.modulate = Color.BLACK
	button1.modulate = Color.BLACK
	button2.modulate = Color.BLACK

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var now = float(Time.get_ticks_msec()) / 1000.0
	dead_label.modulate = Color.BLACK.lerp(Color.WHITE, clamp(now - (show_start + 1.0), 0.0, 1.0))
	description_label.modulate = Color.BLACK.lerp(Color.WHITE, clamp(now - (show_start + 2.0), 0.0, 1.0))
	button1.modulate = Color.BLACK.lerp(Color.WHITE, clamp(now - (show_start + 3.0), 0.0, 1.0))
	button2.modulate = Color.BLACK.lerp(Color.WHITE, clamp(now - (show_start + 3.0), 0.0, 1.0))

func _on_continue_pressed():
	main_scene.back_to_checkpoint()

func _on_menu_pressed():
	main_scene.stop_game()
	main_scene.set_mode(1)
