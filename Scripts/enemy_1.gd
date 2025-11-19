extends CharacterBody2D
var health = 30

func take_damage(amount):
	health -= amount
	print("Enemy took damage! Health:", health)
	if health <= 0:
		queue_free()
