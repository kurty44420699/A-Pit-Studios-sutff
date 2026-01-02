extends CharacterBody2D

enum State {
	IDLE,
	WALK,
	JUMP,
	DASH,
	ATTACK
}

var current_state: State = State.IDLE

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 750.0

var has_acquired_dash = false
var can_dash := true
var facing_direction := 1  


@onready var sprite := $AnimatedSprite2D
@onready var attack_area := $AttackArea

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

	match current_state:
		State.IDLE:
			idle_logic()
		State.WALK:
			walk_logic()
		State.JUMP:
			jump_logic()
		State.DASH:
			dash_logic()
		State.ATTACK:
			attack_logic()

	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor() and current_state != State.DASH:
		velocity += get_gravity() * delta

func idle_logic() -> void:
	velocity.x = move_toward(velocity.x, 0, SPEED)
	sprite.play("Idle Animation")

	var direction = Input.get_axis("Move_Left", "Move_Right")
	if direction != 0:
		current_state = State.WALK
		return

	if Input.is_action_just_pressed("Move_Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = State.JUMP
		return

	if Input.is_action_just_pressed("Punch"):
		enter_attack_state()

func walk_logic() -> void:
	var direction = Input.get_axis("Move_Left", "Move_Right")

	if direction != 0:
		facing_direction = sign(direction)

	if direction == 0:
		current_state = State.IDLE
		return

	velocity.x = direction * SPEED
	sprite.flip_h = facing_direction == -1
	sprite.play("Walking Animation")

	if Input.is_action_just_pressed("Move_Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = State.JUMP
		return

	if has_acquired_dash and Input.is_action_just_pressed("Dash") and can_dash:
		enter_dash_state(direction)
		return

	if Input.is_action_just_pressed("Punch"): #Guys we need a better attack animation
		enter_attack_state()


func jump_logic() -> void:
	var direction = Input.get_axis("Move_Left", "Move_Right")
	if direction != 0:
		facing_direction = sign(direction)
	velocity.x = direction * SPEED
	sprite.flip_h = facing_direction == -1

	#if velocity.y < 0:
		#sprite.play("Jump Animation") #Please send me a jump animation already
	#else:
		#sprite.play("Fall Animation") #don't forget the fall animation too

	if is_on_floor():
		current_state = State.IDLE
		return

	if has_acquired_dash and Input.is_action_just_pressed("Dash") and can_dash:
		enter_dash_state(direction)

func enter_dash_state(direction: float) -> void:
	can_dash = false
	current_state = State.DASH
	velocity.x = direction * DASH_SPEED
	velocity.y = 0
	$Dash_timer.start()
	$Can_dash_again_timer.start()

func dash_logic() -> void:
	sprite.play("Dash Animation")

func _on_dash_timer_timeout() -> void: 
	current_state = State.JUMP
# this function makes it stop having super speed

func _on_can_dash_again_timer_timeout() -> void:
	if is_on_floor():
		can_dash = true

func enter_attack_state() -> void:
	current_state = State.ATTACK
	velocity.x = 0

	# FORCE HURTBOX FLIP
	attack_area.scale.x = facing_direction

	attack_area.monitoring = true
	sprite.play("Punch Animation")
	attack_sequence()

func attack_logic() -> void:
	pass

func _on_attack_area_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(10)

func attack_sequence() -> void:
	await get_tree().create_timer(0.25).timeout
	attack_area.monitoring = false
	await get_tree().create_timer(0.4).timeout
	current_state = State.IDLE
