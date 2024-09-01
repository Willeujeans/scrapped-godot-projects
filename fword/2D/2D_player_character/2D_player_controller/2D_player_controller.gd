extends CharacterBody2D

signal sword_thrown(swords_thrown)

@export var death_animation_scene: PackedScene
@export var sword_scene: PackedScene
@export var speed: float = 410.0
@export var jump_velocity: float = -200.0
@export var max_jump_height: float = -300.0
@export var lerp_speed: float = 0.5
@export var friction: float = 16.0
@export var acceleration: float = 100.0
@export var max_jumps: int = 1

@export_category("bool")
@export var can_wall_jump: bool = false
@export var can_double_jump: bool = false
@export var can_crouch: bool = false

@export_category("collisions")
@export var standing_collision: CapsuleShape2D
@export var crouching_collision: CapsuleShape2D

@onready var height: float = standing_collision.get_height()
@onready var jumps_left: int = max_jumps

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_act: bool = false
var facing_direction: int = 1
var locked_facing: bool = false
var direction: Vector2 = Vector2.ZERO
var is_crouching: bool = false
var is_looking_up = false
var is_jumping = false
var current_jump_height = 0

# Sword
var is_holding_sword: bool = false
var swords_thrown: int = 0
var rotate_power: float = 11.0
var throw_power: float = 650.0
const LERP_SPEED: float = 0.5
@onready var sword_spawner = $CollisionShape2D/Head/SwordSpawner

var direction_mod: int = 1


func _ready():
	print("player added to scene.")

func throw_sword():
	if !$Sword.visible:
		return
	$SwordCooldown.start()
	$HoldTime.stop()
	swords_thrown += 1
	sword_thrown.emit(swords_thrown)
	$Sword.visible = false
	is_holding_sword = false
	var sword = sword_scene.instantiate()
	if direction.y > 0:
		sword.is_upright = true
		sword.set_lock_rotation_enabled(true)
		sword.position = sword_spawner.global_position
		sword.linear_velocity.y = -1 * throw_power
		sword.impact_direction = 0
		$Sword.visible = false
	else:
		sword.position = sword_spawner.global_position
		if is_crouching:
			sword.linear_velocity.x = facing_direction * (throw_power/2)
		else:
			sword.linear_velocity.x = facing_direction * throw_power
		sword.linear_velocity.y = -500
		sword.impact_direction = facing_direction
		if is_crouching:
			sword.set_angular_velocity((rotate_power/1.5) * facing_direction)
		else:
			sword.set_angular_velocity(rotate_power * facing_direction)
		$Sword.visible = false
	get_parent().add_child(sword)


func sword_animation(delta):
	if $SwordCooldown.is_stopped():
		$Sword.visible = true
		
	if is_holding_sword:
		$Sword.rotation = lerp_angle($Sword.rotation, deg_to_rad(30.0 * facing_direction * -1), LERP_SPEED)
		
	if !is_holding_sword:
		if direction.x:
			$Sword.rotation = lerp_angle($Sword.rotation, deg_to_rad(45.0 * facing_direction * -1), LERP_SPEED)
			
		if !direction.x:
			$Sword.rotation = lerp_angle($Sword.rotation, deg_to_rad(100.0 * facing_direction * -1), LERP_SPEED/1.5)


func _physics_process(delta):
	fall(gravity, delta)
	if direction.x < 0:
		direction_mod = 1
	if direction.x > 0:
		direction_mod = -1
	handle_inputs()
	print(is_jumping)
	jump()
	move(delta)
	facing()
	handle_animations(delta)
	coyote_timer()


func fall(gravity, delta):
	if !can_act and is_on_floor():
		can_act = true

	if not is_on_floor():
		velocity.y += gravity * 1.1 * delta
	else:
		jumps_left = max_jumps


func handle_inputs():
	if !can_act:
		return
	
	# Throw Sword
	if Input.is_action_pressed("main_action"):
		if $HoldTime.is_stopped():
			$HoldTime.start() 
		is_holding_sword = true
	if Input.is_action_just_released("main_action") and is_holding_sword:
		is_holding_sword = false
		throw_sword()
		
	# Jump
	if Input.is_action_pressed("jump"):
		if is_on_floor() or !$CoyoteTimer.is_stopped() and !is_jumping:
			velocity.y = 0
			velocity.y += jump_velocity
			$AnimatedSprite2D.play("jump")
			is_jumping = true
	if Input.is_action_just_released("jump"):
		print("released jump")
		is_jumping = false
	# Crouch
	if Input.is_action_pressed("move_down"):
		if !is_crouching:
			crouch()
	elif !$RayCast2D.is_colliding():
		if is_crouching:
			stand()
	# look up
	if Input.is_action_pressed("move_up"):
		is_looking_up = true
	else:
		is_looking_up = false
	# Move
	direction = Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_down","move_up"))
	maximize_directional_input()

func jump():
	print(velocity.y)
	if is_jumping:
		if current_jump_height < max_jump_height:
			current_jump_height = 0
			is_jumping = false
		else:
			current_jump_height += jump_velocity
			velocity.y += jump_velocity
	else:
		if current_jump_height > 0:
			current_jump_height -= jump_velocity
			velocity.y -= jump_velocity
	

func stand():
	$CollisionShape2D.position.y = 0.0
	$CollisionShape2D.set_shape(standing_collision)
	is_crouching = false


func crouch():
	$AnimatedSprite2D.play("crouch")
	$CollisionShape2D.position.y += (height - crouching_collision.get_height())/2
	$CollisionShape2D.set_shape(crouching_collision)
	is_crouching = true


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
		facing_direction = -1
	if direction.x > 0:
		$AnimatedSprite2D.set_flip_h(false)
		facing_direction = 1


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


func handle_animations(delta):
	sword_animation(delta)
	walking_animation()
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


func walking_animation():
	if direction.x and is_on_floor():
			var walkSounds = [$Sounds/FootOne, $Sounds/FootTwo, $Sounds/FootThree]
			$RotationWalkTimer.start()
			if $WalkTimer.is_stopped():
				walkSounds.pick_random().play()
				$WalkTimer.start()
				
	if direction.x:
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.set_rotation_degrees(-5)
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.set_rotation_degrees(5)
	
	if !is_on_floor() || !direction.x:
		$AnimatedSprite2D.set_rotation_degrees(0)

func kill_self():
	if !can_act:
		return
	$Sounds/DeathSound.play()
	can_act = false
	$CollisionShape2D.set_deferred("disabled", true)
	get_tree().get_first_node_in_group("player_camera").screen_shake(10.0, 4.0)
	if get_tree().get_first_node_in_group("crt"):
		get_tree().get_first_node_in_group("crt").shake_aberration()
	var death_animation = death_animation_scene.instantiate()
	death_animation.position = position
	death_animation.set_cube_count(9)
	get_tree().get_first_node_in_group("level").call_deferred("add_child", death_animation)
	set_visible(false)
	get_tree().get_first_node_in_group("level").restart()
