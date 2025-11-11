extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0
const DASH_SPEED = 750

var has_acquired_dash = false
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
	
	if has_acquired_dash: #checks if it acquired dash ability
		#The if body runs when the dash ability has been acquired
		if Input.is_action_just_pressed("Dash") and can_dash: #checks if it used dash button and hasn't dashed yet
			dashing = true
			can_dash = false
			$Dash_timer.start()
			$Can_dash_again_timer.start()
	
	# Horizontal movement, Dashing, Animation and Character flipping
	if not attacking:  # Only move if not attacking
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

	
	#if character position x == 874.0 and character position y == 5:
	#	has_acquired_dash = true
	move_and_slide()

func _on_dash_timer_timeout() -> void: 
	dashing = false
# this function makes it stop having super speed

func _on_can_dash_again_timer_timeout() -> void:
	if is_on_floor():
		can_dash = true

var attacking = false
var can_attack = true

func _input(_event):
	if Input.is_action_just_pressed("Punch") and can_attack:
		perform_attack()

@onready var attack_area = $AttackArea

func perform_attack():
	print("Attack triggered!")
	can_attack = false
	attacking = true
	attack_area.monitoring = true
	sprite.play("Punch Animation")  
	await get_tree().create_timer(0.25).timeout  # attack duration
	attack_area.monitoring = false
	attacking = false
	await get_tree().create_timer(0.4).timeout  # cooldown
	can_attack = true

func _on_attack_area_body_entered(body: Node2D) -> void:
	print("Hit something:", body.name)
	if body.is_in_group("Enemy"):
		body.take_damage(10)
		if body.health - 10 <= 0:
			has_acquired_dash = true
			print("Dash unlocked!")
