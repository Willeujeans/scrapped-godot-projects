extends RigidBody2D

@export var speed: float = 3.0
@export var lerp_speed: float = 0.5
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_act: bool = true
var direction: Vector2 = Vector2.ZERO
var epsilon = 0.1
var can_activate_limbs = true


func _physics_process(delta):
	fall(gravity, delta)
	handle_inputs()
	move(delta)
	handle_animations()


func fall(gravity, delta):
	linear_velocity.y += gravity * delta


func handle_inputs():
	if !can_act:
		return
	# Move
	direction = Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_down","move_up"))
	maximize_directional_input()
	if !can_activate_limbs:
		return
	if Input.is_action_pressed("h"):
		activate_from_key("h")
	if Input.is_action_pressed("j"):
		activate_from_key("j")
	if Input.is_action_pressed("k"):
		activate_from_key("k")
	if Input.is_action_pressed("l"):
		activate_from_key("l")


func activate_from_key(key):
	for each in get_tree().get_nodes_in_group("limb"):
		if each.trigger_button == key:
			each.activate()


func maximize_directional_input():
	if direction.x > 0:
		direction.x = 1
		$AnimatedSprite2D.play("tip_right")
	if direction.x < 0:
		direction.x = -1
		$AnimatedSprite2D.play("tip_left")
	if direction.x == 0:
		direction.x = 0
	direction.normalized()


func move(delta):
	if direction.x:
		set_angular_velocity(direction.x * speed)


func handle_animations():
	if rotation > 1.56875228881836 - epsilon and rotation < 1.56875228881836 + epsilon:
		$AnimatedSprite2D.play("on_side_right")
		return
	if rotation < -1.56875228881836 + epsilon and rotation > -1.56875228881836 - epsilon:
		$AnimatedSprite2D.play("on_side_left")
		return
	if sin(rotation - (PI/2)) < 0:
		if abs(angular_velocity) > 0.4:
			if angular_velocity > 0:
				$AnimatedSprite2D.play("tip_right")
			else:
				$AnimatedSprite2D.play("tip_left")
		else:
			$AnimatedSprite2D.play("upright")
	else:
		if abs(angular_velocity) > 0.4:
			if angular_velocity > 0:
				$AnimatedSprite2D.play("upsidedown_tip_right")
			else:
				$AnimatedSprite2D.play("upsidedown_tip_left")
		else:
			$AnimatedSprite2D.play("upsidedown")


func play_clink():
	if linear_velocity.y >= 30.0:
		$Clink.pitch_scale = randf_range(0.6, 0.9)
		$Clink.play()


func _on_body_entered(body):
	play_clink()
