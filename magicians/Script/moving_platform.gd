extends PathFollow2D

@export var speed := 80.0
@export var start_offset := 0.0
var carried_player = null

var direction := 1.0
@onready var player_scene := get_tree().current_scene

func _ready():
	progress = start_offset


func _process(delta):
	progress += speed * direction * delta

	if not loop and (progress_ratio >= 1.0 or progress_ratio <= 0.0):
		direction *= -1.0

	if carried_player != null:
		carried_player.platform_velocity = Vector2.RIGHT * speed * direction

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		carried_player = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		body.platform_velocity = Vector2.ZERO
		carried_player = null
