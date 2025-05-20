extends Node

var levels = [
	{ "label": "Nivel 1-1", "scene": "res://Niveles/nivel_1.tscn" }
]

var current_level_index := 0
var pending_transition: Dictionary = {}

func get_current_level():
	return levels[current_level_index]
	
func start_level(level_data: Dictionary):
	pending_transition = level_data
	get_tree().change_scene_to_file("res://UI/LevelTransition.tscn")

func restart_current_level():
	var level = get_current_level()
	start_level(level)

func load_main_menu():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func load_game_over():
	get_tree().change_scene_to_file("res://UI/GameOver.tscn")
