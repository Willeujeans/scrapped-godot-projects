extends CharacterBody2D
var direction = 1
var speed = 100.0
var dict_rays: Dictionary = {}
var is_grabbing = false
var current_target
var active_hand
@onready var hands = [$HandA, $HandB]
@onready var starting_hand_positions = [$HandA.position, $HandB.position]
@onready var state = states.SEARCHING

enum states {
	IDLE,
	SEARCHING,
	REACHING,
	GRABBING,
	THROWING
	}


func _physics_process(delta):
	track_targets()
	match state:
		states.IDLE:
			return
		states.SEARCHING:
			print("searching")
			hands[0].get_node("AnimatedSprite2D").play("default")
			hands[1].get_node("AnimatedSprite2D").play("default")
			search_move(delta)
		states.REACHING:
			print("reaching")
			active_hand = hands[0]
			active_hand.get_node("AnimatedSprite2D").play("reaching")
			move_hand_towards_target(active_hand, delta)
		states.GRABBING:
			print("grabing")
			grasping(active_hand)
			go_home(0, delta)
		states.THROWING:
			print("throwing")
	track_targets()


func search_move(delta):
	if $Timer.is_stopped():
		blink()
	if $RightRayCast.is_colliding():
		direction = -1
	if $LeftRayCast.is_colliding():
		direction = 1
	if direction > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	velocity.x = speed * direction
	move_and_slide()


func blink():
	$PointLight2D.enabled = false
	$AnimatedSprite2D.play("blink")


func _on_animated_sprite_2d_animation_finished():
	$PointLight2D.enabled = true
	$AnimatedSprite2D.play("default")
	$Timer.start()


func track_targets():
	for each in $Area2D.get_overlapping_bodies():
		if each.is_in_group("target"):
			dict_rays[each].target_position = self.to_local(each.position)
			if dict_rays[each].get_collider() == each and state == states.SEARCHING:
				current_target = each
				state = states.REACHING


func _on_area_2d_body_entered(body):
	print(body)
	if body.is_in_group("target"):
		var new_ray: RayCast2D = RayCast2D.new()
		new_ray.hit_from_inside = true
		call_deferred("add_child", new_ray)
		dict_rays[body] = new_ray


func _on_area_2d_body_exited(body):
	if body.is_in_group("target"):
		dict_rays[body].queue_free()
		dict_rays.erase(body)


func grasping(hand):
	current_target.set_collision_layer_value(1, false)
	hand.get_node("AnimatedSprite2D").position.y = -130.0
	hand.get_node("AnimatedSprite2D").play("grabbing")
	current_target.position = hand.global_position


func move_hand_towards_target(hand, delta):
	hand.position = hand.position.lerp(to_local(current_target.position), delta * 1.6)
	if hand.position.distance_to(to_local(current_target.position)) <= 10.0:
		state = states.GRABBING


func go_home(hand_index, delta):
	hands[hand_index].position = hands[hand_index].position.lerp(starting_hand_positions[hand_index], delta * 1.6)
	if hands[hand_index].position.distance_to(starting_hand_positions[hand_index]) <= 10.0:
		throw_target()


func throw_target():
	active_hand.get_node("AnimatedSprite2D").position.y = 0.0
	current_target.linear_velocity = Vector2(-1000, -1000)
	current_target.set_collision_layer_value(1, true)
	state = states.IDLE
	$Refactory.start()
	await $Refactory.timeout
	state = states.SEARCHING
