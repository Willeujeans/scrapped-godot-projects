extends CharacterBody2D

const SPEED : float = 600.0
const DASH_SPEED : float = 1300.0
const JUMP_VELOCITY : float = -800.0
var gravity : float = 1800.0

var canDoubleJump : bool = true
var canDash : bool = true
var isDashing : bool = false
var isFacingLeft : bool = false
var isJumping : bool = false

func _physics_process(delta):
	if isDashing:
		velocity.y = 0
		if isFacingLeft:
			velocity.x = -1 * DASH_SPEED
		else:
			velocity.x = 1 * DASH_SPEED
	else:
		if not is_on_floor():
			velocity.y += gravity * delta
			if velocity.y > 0:
				$walking_particles.emitting = false
				$AnimatedSprite2D.play("Fall")
		else:
			canDoubleJump = true
			canDash = true
		var upDown = Input.get_axis("up","down");
		var direction = Input.get_axis("left", "right")
		if direction < 0:
			direction = -1;
			
		if direction > 0:
			direction = 1
	
		if direction:
			velocity.x = direction * SPEED
			if is_on_floor():
				$walking_particles.emitting = true
				$AnimatedSprite2D.play("Run")
			if direction == 1:
				isFacingLeft = false
				$AnimatedSprite2D.flip_h = false
			elif direction == -1:
				isFacingLeft = true
				$AnimatedSprite2D.flip_h = true
		else:
			if is_on_floor():
				$walking_particles.emitting = false
				$AnimatedSprite2D.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
		if Input.is_action_just_pressed("dash") && canDash:
			isDashing = true
			canDash = false
			$walking_particles.emitting = false
			$AnimatedSprite2D.play("Dash")
			$dash_particles.direction.x = direction * -1
			$dash_particles.emitting = true
	
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				$walking_particles.emitting = false
				$AnimatedSprite2D.play("Jump")
			elif canDoubleJump && !is_on_floor():
				velocity.y = JUMP_VELOCITY
				$walking_particles.emitting = false
				$AnimatedSprite2D.play("Flap")
				canDoubleJump = false

		if Input.is_action_just_pressed("attack"):
			if Input.is_action_pressed("up"):
				$arm/topSwing.play("slash")
			elif Input.is_action_pressed("down") and !is_on_floor():
				$arm/bottomSwing.play("slash")
			elif isFacingLeft:
				$arm/backwardSwing.play("slash")
			elif !isFacingLeft:
				$arm/forwardSwing.play("slash")
		
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	if isDashing:
		isDashing = false
