extends Node2D

func _init() -> void:
	print("Game is Initializing...")

func _enter_tree() -> void:
	print("Game has entered the tree")

func _ready() -> void:
	print("Game is ready")

func _physics_process(_delta: float) -> void:
	pass

func _process(_delta: float) -> void:
	pass
