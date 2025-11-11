extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scene/game.tscn")
	print("I am inside the Game!!!")

func _on_options_pressed() -> void:
	print("Options button pressed!")

func _on_quit_pressed() -> void:
	get_tree().quit()
