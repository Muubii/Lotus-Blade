extends Control

func _on_back_home_pressed() -> void:
	get_tree().change_scene_to_file("res://main-menu.tscn")
