extends CharacterBody2D

@export var speed = 400
@onready var animated_sprite = $AnimatedSprite2D
@export var attacking = false
@export var attack_damage = 5
@export var health = 100
@export var health_max = 100
@export var health_min = 0

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		attack()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if !attacking:
		if input_direction.y < 0:
			animated_sprite.play("run_up")
		elif input_direction.y > 0:
			animated_sprite.play("run_down")
		elif input_direction.x != 0:
			animated_sprite.play("run_right")
			animated_sprite.flip_h = input_direction.x < 0
		else:
			animated_sprite.play("idle_down")

func attack():
	print("Attack function called")
	var overlapping_areas = $attackArea.get_overlapping_areas()
	print("Overlapping areas count: ", overlapping_areas.size())
	for area in overlapping_areas:
		var enemy = area.get_parent()
		if enemy.has_method("take_damage"):
			print("Damaging enemy: ", enemy.name)
			enemy.take_damage(attack_damage) # Pass the desired damage value here
	attacking = true
	animated_sprite.play("atack1.down")

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
	# Change to main menu scene on player death
	get_tree().change_scene_to_file("res://main-menu/main-menu.tscn")

func _on_animation_finished():
	if animated_sprite.animation == "atack1.down":
		attacking = false

func _physics_process(_delta):
	get_input()
	move_and_slide()
