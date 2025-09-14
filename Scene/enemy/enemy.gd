extends CharacterBody2D

@onready var target = $"../player"
@onready var attack_area = $Area2D/attackArea  # Adjust as needed for your structure

var speed: float = 100
var health: int = 80
var health_max: int = 80
var health_min: int = 0
var attack_damage: int = 25       # DAMAGE PER HIT (increase for more)
var attack_cooldown: float = 0.3  # SECONDS BETWEEN ATTACKS (lower for faster)
var time_since_last_attack: float = 0.0

func _physics_process(delta):
	time_since_last_attack += delta

	var direction = (target.position - position).normalized()
	velocity = direction * speed
	look_at(target.position)
	move_and_slide()

	if attack_area and attack_area.overlaps_body(target):
		if time_since_last_attack >= attack_cooldown:
			attack_player()
	# Optional: Uncomment below to reset cooldown on exit
	# else:
	#	time_since_last_attack = attack_cooldown

func attack_player():
	if target.has_method("take_damage"):
		print("Enemy attacking player")
		target.take_damage(attack_damage)
		time_since_last_attack = 0.0

func take_damage(amount: int = 1):
	health -= amount
	if health < health_min:
		health = health_min
	if health <= health_min:
		die()

func heal(amount: int = 1):
	health += amount
	if health > health_max:
		health = health_max

func die():
	queue_free()
