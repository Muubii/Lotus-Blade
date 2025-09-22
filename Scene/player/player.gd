extends CharacterBody2D

@export var speed = 200
@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

@export var attacking = false
@export var attack_damage = 20
@export var health = 100
@export var health_max = 100
@export var health_min = 0

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _process(_delta):
	if Input.is_action_just_pressed("attack") and !attacking:
		attack()

func _input(event):
	if event.is_action_pressed("ui_interact"):
		interact()
	elif event.is_action_pressed("advance_dialog"):
		# If player should handle dialog advance locally, put logic here
		pass

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
		if enemy and enemy.has_method("take_damage"):
			print("Damaging enemy: ", enemy.name)
			enemy.take_damage(attack_damage)
	attacking = true
	animated_sprite.play("atack1.down")

func interact():
	var overlapping_bodies = interaction_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.has_method("start_dialog"):
			body.start_dialog(global_position)
			break

func take_damage(amount: int = 1):
	health -= amount
	health = clamp(health, health_min, health_max)
	if health <= health_min:
		die()

func heal(amount: int = 1):
	health = clamp(health + amount, health_min, health_max)

func die():
	# Change to main menu scene on player death
	get_tree().change_scene_to_file("res://main-menu/main-menu.tscn")

func _on_animation_finished():
	if animated_sprite.animation == "atack1.down":
		attacking = false

func _physics_process(_delta):
	get_input()
	move_and_slide()
