extends Node

@onready var text_box_scene = preload("res://Scene/text-box/text-box.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var tex_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

func _ready():
	set_process_unhandled_input(true)  # Enable unhandled input callback

func start_dialog(position: Vector2, lines: Array[String]):
	if is_dialog_active:
		return
	dialog_lines = lines
	tex_box_position = position
	current_line_index = 0
	_show_text_box()
	is_dialog_active = true

func _show_text_box():
	if text_box:
		print("Freeing previous text box")
		text_box.queue_free()

	print("Instantiating new text box")
	text_box = text_box_scene.instantiate()
	get_tree().root.call_deferred("add_child", text_box)
	text_box.global_position = Vector2(400, 300)  # Fixed position for visibility
	text_box.visible = true
	text_box.call_deferred("display_text", dialog_lines[current_line_index])

	var connected_callable = Callable(self, "_on_text_box_finished_displaying")
	if text_box.is_connected("finished_displaying", connected_callable):
		text_box.disconnect("finished_displaying", connected_callable)
	text_box.connect("finished_displaying", connected_callable)

	can_advance_line = false
	print("Text box shown for line: ", dialog_lines[current_line_index])

func _on_text_box_finished_displaying():
	can_advance_line = true
	print("Dialog line finished displaying; can advance now.")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog") and is_dialog_active and can_advance_line:
		print("Advancing dialog")
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			print("Dialog complete")
			return
		_show_text_box()
