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
	get_tree().paused = false # needs to be paused before changing so the buttons work
	print("Quitted to Main Menu")
	get_tree().change_scene_to_file("res://Game Scene/control.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("Escape"):
		if not get_tree().paused:
			pause()
		else:
			resume()
