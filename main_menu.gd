extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://addons/godot_super-wakatime/counter.tscn")



func _on_settings_pressed() -> void:
	print("start sett")



func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Credits/credits.tscn")


#func _on_exit_pressed() -> void:
	#get_tree().quit()
