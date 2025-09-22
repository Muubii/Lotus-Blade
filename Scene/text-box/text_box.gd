extends MarginContainer

@export var bubble_position: Vector2 = Vector2.ZERO  # Allow setting dialog bubble position

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var puncturation_time = 0.2

signal finished_displaying

func _ready():
	print("TextBox scene ready and in tree!")
	print("Label node is: ", label)
	timer.timeout.connect(_on_LetterDisplayTimer_timeout)

func display_text(text_to_display):
	print("Displaying text: ", text_to_display)
	text = text_to_display
	# Calculate size and wrap before starting letter display
	label.text = text_to_display
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y

	# Set the bubble position dynamically
	global_position = bubble_position

	# Reset text for typewriter effect
	label.text = ""
	letter_index = 0
	_display_letter()

func _display_letter():
	if letter_index < text.length():
		label.text += text[letter_index]
		var ch = text[letter_index]
		letter_index += 1
		print("Displaying char: '", ch, "' at index ", letter_index)
		match ch:
			"!", ".", ",", "?":
				print("Starting punctuation timer")
				timer.start(puncturation_time)
			" ":
				print("Starting space timer")
				timer.start(space_time)
			_:
				print("Starting letter timer")
				timer.start(letter_time)
	else:
		print("Finished displaying full text")
		emit_signal("finished_displaying")

func _on_LetterDisplayTimer_timeout():
	print("Timer timeout received")
	_display_letter()
