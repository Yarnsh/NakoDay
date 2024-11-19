extends Area3D

func _on_body_entered(body):
	var fade = $"../PlayerStuff/Fade/Fade"
	fade.animation_finished.connect(_on_animation_finished)
	fade.play("FadeOut")

func _on_animation_finished(anim):
	Global.main.show_credits()
