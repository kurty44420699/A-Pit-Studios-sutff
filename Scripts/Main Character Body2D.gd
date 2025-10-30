extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var sprite := $"AnimatedSprite2D"

func _physics_process(delta: float) -> void:
	# Gravity
	velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("Move_Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement,Animation and flipping
	var x_position = Input.get_axis("Move_Left", "Move_Right")
	if x_position: 
		velocity.x = SPEED * x_position
		sprite.play("Walking Animation")
		sprite.flip_h = x_position < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("Idle Animation")

	move_and_slide()
