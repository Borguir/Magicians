extends Area2D

@export var speed := 500.0
@export var damage := 1

var direction := Vector2.ZERO

func _ready():
	$CollisionShape2D.disabled = false
	if direction.x < 0:
		$Sprite2D.scale.x = -1
	else:
		$Sprite2D.scale.x = 1
		
	

func _physics_process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(damage)
	queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
