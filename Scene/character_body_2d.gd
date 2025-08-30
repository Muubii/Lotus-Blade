extends CharacterBody2D

@export var speed = 400
@onready var animated_sprite = $AnimatedSprite2D
@export var attacking = false

func _ready():
	# Connect the animation_finished signal
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _process(delta):
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
	var overlapping_objects = $attackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		var parent = area.get_parent()
		parent.take_damage()
	
	attacking = true
	animated_sprite.play("atack1.down")

func _on_animation_finished():
	# Only reset if attack animation has ended
	if animated_sprite.animation == "atack1.down":
		attacking = false

func _physics_process(_delta):
	get_input()
	move_and_slide()
