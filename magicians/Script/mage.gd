extends CharacterBody2D


@export var spell_scene: PackedScene
@export var shoot_interval := 1.0  # segundos entre disparos
@export var health := 3

func _ready():
	$Timer.wait_time = shoot_interval
	$Timer.start()
	$Timer.timeout.connect(_on_Timer_timeout)

func _on_Timer_timeout():
	shoot()

func shoot():
	var spell = spell_scene.instantiate()
	spell.global_position = $fire_point.global_position
	spell.direction = Vector2.RIGHT  # Siempre dispara a la izquierda
	get_tree().current_scene.add_child(spell)

func take_damage(amount: int):
	health -= amount
	print("Mage hit! Health:", health)
	if health <= 0:
		die()

func die():
	print("Mage defeated!")
	queue_free()
