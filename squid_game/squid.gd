extends RigidBody2D
# add air strafing

@export var ink_scene: PackedScene
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var instance_tracker = 0
var speed = 25.0

func _ready():
	get_tree().get_first_node_in_group("AnimationHandler").animate.connect(play_next_frame)


func _physics_process(delta):
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
	var ink_instance = ink_scene.instantiate()
	var direction = ($Reticle/Pointer.global_position - self.global_position).normalized()
	var magnitude = 1500.0
	ink_instance.instance_number = instance_tracker
	instance_tracker += 1
	ink_instance.linear_velocity = direction * magnitude
	get_parent().call_deferred("add_child", ink_instance)
	ink_instance.global_position = self.global_position
	

func _process(delta):
	var look_pos = Vector2(linear_velocity.x * 1.1, linear_velocity.y * 1.1)
	$AnimatedSprite2D.look_at(to_global(look_pos))
	if linear_velocity.length() <= 100.0:
		$AnimatedSprite2D.look_at(Vector2(global_position.x, global_position.y - 100.0))


func play_next_frame(current_frame):
	if current_frame == 0:
		$AnimatedSprite2D.play("one")
		$Reticle.play("one")
	else:
		$AnimatedSprite2D.play("two")
		$Reticle.play("two")
