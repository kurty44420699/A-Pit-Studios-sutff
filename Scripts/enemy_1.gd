extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	ATTACK,
	HURT,
	DEAD
}

var current_state: State = State.IDLE
var health := 30

const SPEED := 80.0
const ATTACK_RANGE := 30.0

@onready var sprite := $AnimatedSprite2D
@onready var player := get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			idle_logic()
		State.CHASE:
			chase_logic()
		State.ATTACK:
			attack_logic()
		State.HURT:
			hurt_reaction()
		State.DEAD:
			pass

	move_and_slide()

func idle_logic() -> void:
	#sprite.play("idle")

	if player and position.distance_to(player.position) < 200:
		current_state = State.CHASE

func chase_logic() -> void:
	if not player:
		current_state = State.IDLE
		return

	var direction = sign(player.position.x - position.x)
	velocity.x = direction * SPEED
	sprite.flip_h = direction < 0
	#sprite.play("walk")

	if position.distance_to(player.position) <= ATTACK_RANGE:
		current_state = State.ATTACK

func attack_logic() -> void:
	velocity.x = 0
	#sprite.play("attack")

	# You would trigger damage using an Area2D or animation signal

func take_damage(amount: int) -> void:
	if current_state == State.DEAD:
		return

	health -= amount
	print("Enemy took damage! Health:", health)

	if health <= 0:
		current_state = State.DEAD
		die()
	else:
		current_state = State.HURT
		hurt_reaction()

func hurt_reaction() -> void:
	#sprite.play("hurt")
	await get_tree().create_timer(0.2).timeout
	current_state = State.CHASE

func die() -> void:
	#sprite.play("death")
	await get_tree().create_timer(0.5).timeout
	queue_free()
