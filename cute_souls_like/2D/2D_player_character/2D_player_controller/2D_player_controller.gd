extends CharacterBody2D

@export var speed: float = 1000.0
@export var jump_velocity: float = -700.0
@export var lerp_speed: float = 0.5
@export var friction: float = 16.0
@export var acceleration: float = 100.0
@export var max_jumps: int = 1
@export var wall_jump_push: float = 350.0

@export_category("bool")
@export var can_wall_jump: bool = false
@export var can_double_jump: bool = false
@export var can_crouch: bool = false

@export_category("collisions")
@export var standing_collision: CapsuleShape2D

@onready var height: float = standing_collision.get_height()
@onready var jumps_left: int = max_jumps

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_act: bool = true
var facing_right: bool = true
var locked_facing: bool = false
var direction: Vector2 = Vector2.ZERO
var is_crouching: bool = false
var is_looking_up = false


func _physics_process(delta):
	fall(gravity, delta)
	handle_inputs()
	move(delta)
	facing()
	handle_animations()
	coyote_timer()


func fall(gravity, delta):
	if not is_on_floor():
		if is_on_wall() and velocity.y > 0.0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			velocity.y += (gravity/10.0) * delta
		else:
			velocity.y += gravity * delta
	else:
		jumps_left = max_jumps


func handle_inputs():
	if !can_act:
		return
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_wall():
			if Input.is_action_pressed("move_right"):
				velocity.y = jump_velocity
				velocity.x = wall_jump_push * -1
			if Input.is_action_pressed("move_left"):
				velocity.y = jump_velocity
				velocity.x = wall_jump_push
		elif is_on_floor() or !$CoyoteTimer.is_stopped() or jumps_left > 0:
			jumps_left -= 1
			$AnimatedSprite2D.play("jump")
			velocity.y = jump_velocity
	# look up
	if Input.is_action_pressed("move_up"):
		is_looking_up = true
	else:
		is_looking_up = false
	# Move
	direction = Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_down","move_up"))
	maximize_directional_input()


func stand():
	$CollisionShape2D.position.y = 0.0
	$CollisionShape2D.set_shape(standing_collision)


func maximize_directional_input():
	if direction.x > 0:
		direction.x = 1
	if direction.x < 0:
		direction.x = -1
	if direction.x == 0:
		direction.x = 0
	direction.normalized()


func facing():
	if locked_facing:
		return
	if direction.x < 0:
		$AnimatedSprite2D.set_flip_h(true)
		facing_right = false
	if direction.x > 0:
		$AnimatedSprite2D.set_flip_h(false)
		facing_right = true


func move(delta):
	if direction.x:
		if is_crouching:
			if is_on_floor():
				add_friction()
				return
			else:
				accelerate(direction)
				return
		accelerate(direction)
	else:
		add_friction()


func accelerate(direction):
	velocity.x = move_toward(velocity.x, speed * direction.x, acceleration)


func add_friction():
	velocity.x = move_toward(velocity.x, 0, friction)


func coyote_timer():
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		$CoyoteTimer.start()


func handle_animations():
	if is_looking_up and !is_crouching and abs(velocity.x) < 0.05:
		$AnimatedSprite2D.play("look_up")
		return
	
	if is_crouching:
		$AnimatedSprite2D.play("crouch")
		return
	
	if abs(velocity.x) > 0.05:
		$AnimatedSprite2D.play("move")
		return
	
	$AnimatedSprite2D.play("idle")
