extends CharacterBody2D


const SPEED = 300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1

func _ready():
	$PaintDetector.painted.connect(change_color)
	get_tree().get_first_node_in_group("AnimationHandler").animate.connect(play_next_frame)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if $LeftRay.is_colliding():
		$AnimatedSprite2D.flip_h = true
		direction = 1
	elif $RightRay.is_colliding():
		$AnimatedSprite2D.flip_h = false
		direction = -1
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func play_next_frame(current_frame):
	if current_frame == 0:
		$AnimatedSprite2D.play("one")
	else:
		$AnimatedSprite2D.play("two")

func change_color(touched_by):
	self.modulate = touched_by.modulate
