extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("restart_level"):
		if LevelManager:
			LevelManager.restart_current_level()
		else:
			get_tree().reload_current_scene()

func _on_button_pressed() -> void:
	if LevelManager:
		LevelManager.load_main_menu()
