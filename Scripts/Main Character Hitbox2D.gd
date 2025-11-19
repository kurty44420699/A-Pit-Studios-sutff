extends CollisionShape2D

func _init() -> void:
	print("Hitbox is initialized!")

func _enter_tree() -> void:
	print("Hitbox entered the tree!")

func _ready() -> void:
	print("Hitbox is ready!")
	
