extends Control



func _on_start_pressed():
	var level_info = LevelManager.get_current_level()
	LevelManager.start_level(level_info)  # esto llama a la transición

func _on_quit_pressed() -> void:
	get_tree().quit()
