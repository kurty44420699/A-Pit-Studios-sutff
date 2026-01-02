extends CharacterBody2D

func _ready():
	print("Enemy READY")

enum State {
	IDLE,
	CHASE,
	ATTACK,
	HURT,
	DEAD
}

var current_state: State = State.IDLE
var health := 30
@onready var raycast := $RayCast2D
@onready var attack_area := $AttackArea2D

var can_attack := true
const ATTACK_COOLDOWN := 1.0
const DAMAGE := 10
const SPEED := 80.0
const ATTACK_RANGE := 30.0

#@onready var sprite := $AnimatedSprite2D
@onready var player := get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	velocity = Vector2(100, 0)
	move_and_slide()


func _can_see_player() -> bool:
	if not player:
		return false

	raycast.force_raycast_update()

	if raycast.is_colliding():
		return raycast.get_collider() == player

	return false

func idle_logic() -> void:
	velocity.x = 0
	current_state = State.CHASE


func chase_logic() -> void:
	if not _can_see_player():
		current_state = State.IDLE
		return

	var direction = sign(player.position.x - position.x)
	velocity.x = direction * SPEED

	# Face the player (important for raycast)
	raycast.target_position.x = direction * abs(raycast.target_position.x)

	if position.distance_to(player.position) <= ATTACK_RANGE:
		current_state = State.ATTACK

func _start_attack_cooldown():
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true


func attack_logic() -> void:
	velocity.x = 0

	if not _can_see_player():
		current_state = State.IDLE
		return

	if can_attack and attack_area.get_overlapping_bodies().has(player):
		player.take_damage(DAMAGE)
		can_attack = false
		_start_attack_cooldown()


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
