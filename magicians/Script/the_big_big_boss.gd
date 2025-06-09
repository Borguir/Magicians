extends CharacterBody2D

@export var spell_scene: PackedScene
@export var player_path: NodePath
@export var shoot_interval := 1.0
@export var vulnerable_duration := 2.0
@export var health := 5

var is_vulnerable := false
var player: Node2D
var vulnerable_timer: Timer
var shield_timer: Timer

func _ready():
	player = get_node(player_path)
	$Sprite2D.scale.x = -1
	
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)
	$VulnerableTimer.timeout.connect(_on_vulnerable_timeout)
	$ShieldReturnTimer.timeout.connect(_on_shield_timer_timeout)

	start_shield_cycle()

	
	# Timers para escudo
	vulnerable_timer = Timer.new()
	vulnerable_timer.wait_time = vulnerable_duration
	vulnerable_timer.one_shot = true
	add_child(vulnerable_timer)
	vulnerable_timer.timeout.connect(_on_vulnerable_timeout)
	
	shield_timer = Timer.new()
	shield_timer.wait_time = 3.0
	shield_timer.one_shot = true
	add_child(shield_timer)
	shield_timer.timeout.connect(_on_shield_timer_timeout)

func start_shield_cycle():
	is_vulnerable = false
	$Shield.visible = true
	$ShieldReturnTimer.start()

func _on_shield_timer_timeout():
	print("Escudo desactivado")
	is_vulnerable = true
	$Shield.visible = false
	vulnerable_timer.start()

func _on_vulnerable_timeout():
	("No fue atacado, escudo vuelve")
	start_shield_cycle()

func take_damage(amount):
	if is_vulnerable:
		start_damage_flash()
		print("Boss recibió daño")
		health -= amount
		if health <= 0:
			die()
		else:
			# Reactiva escudo inmediatamente
			vulnerable_timer.stop()
			start_shield_cycle()
	else:
		print("Boss es invulnerable")

func die():
	print("¡Boss derrotado!")
	queue_free()

func _on_shoot_timer_timeout():
	if not player:
		return
	var spell = spell_scene.instantiate()
	spell.global_position = $FirePoint.global_position
	spell.direction = (player.global_position - global_position).normalized()
	get_tree().current_scene.add_child(spell)

func start_damage_flash():
	var mat = $Sprite2D.material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("flash_amount", 1.0)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("flash_amount", 0.0)
