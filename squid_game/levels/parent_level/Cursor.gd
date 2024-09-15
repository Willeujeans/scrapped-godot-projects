extends AnimatedSprite2D


func _ready():
	get_tree().get_first_node_in_group("AnimationHandler").animate.connect(play_next_frame)


func _process(delta):
	if Input.is_action_pressed("ink"):
		$"../AnimationPlayer".play("cursor_click")
	global_position = get_global_mouse_position()


func play_next_frame(current_frame):
	if current_frame == 0:
		play("one")
	else:
		play("two")
