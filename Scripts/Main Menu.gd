extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options_buttons: Panel = $OptionsButtons
@onready var title_name: Label = $Label

func _ready():
	main_buttons.visible= true
	options_buttons.visible= false
	title_name.visible= true

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Game Scene/game.tscn")
	print("I am inside the Game!!!")

func _on_options_pressed() -> void:
	print("Options button pressed!")
	main_buttons.visible= false
	options_buttons.visible= true
	title_name.visible= false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_options_pressed() -> void:
	_ready()
