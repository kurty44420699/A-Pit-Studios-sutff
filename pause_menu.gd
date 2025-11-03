extends Control

func _ready():
	visible = false  # hide on start

func pause():
	get_tree().paused = true
	visible = true   # show menu when paused

func resume():
	get_tree().paused = false
	visible = false  # hide menu when resumed

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()

func _process(_delta):
	if Input.is_action_just_pressed("Escape"):
		if not get_tree().paused:
			pause()
		else:
			resume()
