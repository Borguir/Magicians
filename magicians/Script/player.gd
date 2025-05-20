extends CharacterBody2D

@export var speed := 200.0
@export var jump_force := -400.0
@export var gravity := 1000.0
@export var jump_release_gravity := 2000.0

@export var projectile_scene: PackedScene
@export var cooldown_time := 0.5
@export var max_health := 1

var is_jumping := false
var fire_cooldown := 0.0
var current_health := max_health

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		if is_jumping and not Input.is_action_pressed("jump"):
			velocity.y += jump_release_gravity * delta
		else:
			velocity.y += gravity * delta
	else:
		is_jumping = false

	# Movimiento
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed

	if direction != 0:
		$Sprite2D.scale.x = sign(direction)

	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true

	# Cooldown de disparo
	if fire_cooldown > 0:
		fire_cooldown -= delta

	# Lanzar hechizo
	if Input.is_action_just_pressed("ui_accept") and fire_cooldown <= 0:
		shoot()
		fire_cooldown = cooldown_time

	move_and_slide()

func shoot():
	var projectile = projectile_scene.instantiate()
	var fire_point = $Sprite2D/fire_point.global_position
	projectile.global_position = fire_point

	# Determinar dirección mirando hacia la escala del sprite
	var dir = Vector2(sign($Sprite2D.scale.x), 0)
	projectile.direction = dir

	get_tree().current_scene.add_child(projectile)

func take_damage(amount: int):
	current_health -= amount
	print("Player hit! Health: ", current_health)
	if current_health <= 0:
		die()

func die():
	queue_free()
	LevelManager.load_game_over()
