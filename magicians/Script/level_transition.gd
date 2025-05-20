extends Control

@onready var label = $Label
@onready var anim_player = $AnimationPlayer

func _ready():
	if LevelManager.pending_transition.has("label"):
		label.text = LevelManager.pending_transition.label
	else:
		label.text = "Cargando..."

	anim_player.play("Fade")
	await anim_player.animation_finished

	if LevelManager.pending_transition.has("scene"):
		var scene_path = LevelManager.pending_transition["scene"]
		print("Transicionando a:", scene_path)
		get_tree().change_scene_to_file(scene_path)
	else:
		print("No se encontró 'scene' en pending_transition")
