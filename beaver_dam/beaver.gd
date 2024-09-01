extends CharacterBody2D

var direction: Vector2
const SPEED = 1000.0
var is_facing_right:bool = true


func _physics_process(delta):
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction.y:
		velocity.y = direction.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if direction.x > 0:
		is_facing_right = true
	if direction.x < 0:
		is_facing_right = false
		
	if is_facing_right:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	if velocity.length() >= 1.0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	move_and_slide()
