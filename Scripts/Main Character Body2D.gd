extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0
const DASH_SPEED = 1000

var dashing = false
var can_dash = true

@onready var sprite := $"AnimatedSprite2D"

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor(): # checks if mid air
		velocity += get_gravity() * delta
	
	# Jump
	if Input.is_action_just_pressed("Move_Up") and is_on_floor(): #checks if it jumped
		velocity.y = JUMP_VELOCITY
	
	# Dash checker
	if Input.is_action_just_pressed("Dash") and can_dash: #checjs if it used dash button and hasn't dashed yet
		dashing = true
		can_dash = false
		$Dash_timer.start()
		$Can_dash_again_timer.start()
	
	# Horizontal movement, Dashing, Animation and Character flipping
	var x_direction = Input.get_axis("Move_Left", "Move_Right")
	if x_direction:
		if dashing:
			velocity.x = x_direction * DASH_SPEED
		else:
			velocity.x = x_direction * SPEED
		sprite.play("Walking Animation")
		sprite.flip_h = x_direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("Idle Animation")
	
	move_and_slide()

func _on_dash_timer_timeout() -> void: 
	dashing = false
# this function makes it stop having super speed

func _on_can_dash_again_timer_timeout() -> void:
	if is_on_floor():
		can_dash = true
