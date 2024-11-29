extends Area3D

func _on_body_entered(body):
	var fade = $"../PlayerStuff/Fade/Fade"
	fade.animation_finished.connect(_on_animation_finished)
	fade.play("FadeOut")
	body.stop_action_music()

func _on_animation_finished(anim):
	Global.main.show_credits()

func enable_ending():
	set_collision_mask_value(32, true)
