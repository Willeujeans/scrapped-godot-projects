extends RigidBody2D


@onready var start_position = global_position
@export var ink_scene: PackedScene
@onready var total_scale_pool = $AnimatedSprite2D.scale.x + $AnimatedSprite2D.scale.y
var max_speed = 2700
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var instance_tracker = 0
var speed = 20.0
var time_till_reset = 5.0
var can_play_squish = true
var world_position


func _ready():
	world_position = get_tree().get_first_node_in_group("world").global_position
	get_tree().get_first_node_in_group("AnimationHandler").animate.connect(play_next_frame)


func _physics_process(delta):
	if linear_velocity.x > max_speed:
		linear_velocity.x = max_speed
	if linear_velocity.y > max_speed:
		linear_velocity.y = max_speed
	var sound_number_remapped = remap(linear_velocity.length(), 0, 3000, -55, -15) # Returns 0.5
	$AnimatedSprite2D.scale.x = remap(linear_velocity.length(), 0, 3000, total_scale_pool/2.0, (total_scale_pool/2.0) + 1.1)
	$AnimatedSprite2D.scale.y = total_scale_pool - $AnimatedSprite2D.scale.x
	$WindSound.volume_db = lerp($WindSound.volume_db, sound_number_remapped, delta * 10.0)
	if $WindSound.volume_db > -5:
		$WindSound.volume_db = -5
	if Input.is_action_pressed("left"):
		apply_central_impulse(Vector2(-1.0 * speed, 0.0))
	if Input.is_action_pressed("right"):
		apply_central_impulse(Vector2(1.0 * speed, 0.0))
	if Input.is_action_just_pressed("ink"):
		if $Cooldown.is_stopped():
			shoot_ink()
	$Reticle.look_at(get_global_mouse_position())


func shoot_ink():
	$Cooldown.start()
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.7, 1.2)
	$AudioStreamPlayer2D.play()
	var ink_instance = ink_scene.instantiate()
	var direction = ($Reticle/Pointer.global_position - self.global_position).normalized()
	var magnitude = 2000.0
	ink_instance.instance_number = instance_tracker
	instance_tracker += 1
	ink_instance.linear_velocity = direction * magnitude
	get_parent().call_deferred("add_child", ink_instance)
	ink_instance.global_position = self.global_position
	

func _process(_delta):
	if Input.is_action_pressed("reset"):
		time_till_reset -= 0.1
	if Input.is_action_just_released("reset"):
		time_till_reset = 5.0
	if time_till_reset <= 0.0 or global_position.distance_to(world_position) >= 50_000:
		linear_velocity = Vector2.ZERO
		global_position = start_position
		time_till_reset = 5.0
	var look_pos = Vector2(linear_velocity.x * 1.1, linear_velocity.y * 1.1)
	$AnimatedSprite2D.look_at(to_global(look_pos))
	if linear_velocity.length() <= 100.0:
		$AnimatedSprite2D.look_at(Vector2(global_position.x, global_position.y - 100.0))
	if linear_velocity.length() <= 50.0 and can_play_squish:
		can_play_squish = false
		$AnimationPlayer.play("squish")
	if not can_play_squish and linear_velocity.length() >= 200.0:
		can_play_squish = true


func play_next_frame(current_frame):
	if current_frame == 0:
		$AnimatedSprite2D.play("one")
		$Reticle.play("one")
	else:
		$AnimatedSprite2D.play("two")
		$Reticle.play("two")
