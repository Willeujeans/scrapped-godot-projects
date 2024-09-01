extends CharacterBody2D

@export var speed: float = 200.0
@export var direction: int = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.play("default")


func _physics_process(delta):
	$Movement.updateLastPos()
	if not is_on_floor():
		velocity.y += gravity * delta
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
	$Movement.checkStuck()
