extends CharacterBody2D

@onready var target = $"../player"
var speed = 100
var health = 2  

func _physics_process(delta):
	var direction = (target.position - position).normalized()
	velocity = direction * speed
	look_at(target.position)
	move_and_slide()

func take_damage():
	health -= 1
	if health <= 0:
		die()

func die():
	queue_free()  
