extends CharacterBody2D

@export var dialog_lines: Array[String] = [
	"Hey, you seem pretty strong!",
	"Wanna spar?",
	"Wait what is your name young man?",
	"I shouldn't waste my energy before an important battle...",
	"Well, I'll see you at the buffet!"
]

@onready var area = $Area2D
@onready var interaction_label = $Label

var player_in_range = false

func _ready():
	interaction_label.visible = false
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	set_process_input(true)  # Enable input processing in this node

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		interaction_label.visible = true
		print("Player entered interaction area")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		interaction_label.visible = false
		print("Player left interaction area")

func _input(event):
	if player_in_range and event.is_action_pressed("ui_interact"):
		print("NPC interaction triggers dialog")
		DialogManager.start_dialog(global_position, dialog_lines)
