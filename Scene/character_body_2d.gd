extends CharacterBody2D

@export var speed = 400
@onready var animated_sprite = $AnimatedSprite2D

func get_input():
	# Read four directions at once
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	# Direction-based animation logic
	if input_direction.y < 0:
		animated_sprite.play("run_up")
	elif input_direction.y > 0:
		animated_sprite.play("run_down")
	elif input_direction.x != 0:
		animated_sprite.play("run_right")
		animated_sprite.flip_h = input_direction.x < 0
	else:
		animated_sprite.play("idle_down")

func _physics_process(delta):
	get_input()
	move_and_slide()
