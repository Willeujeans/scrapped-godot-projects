extends Node2D
var speed = 90000.0
var is_extending = false
var trigger_button = "h"
var is_grabbing = false
@onready var hand = $Hand
@onready var my_shape = $Hand/CollisionShape2D
@onready var my_old_parent = null
@onready var attatchment_point = $Hand/AttatchmentPoint
var children_limbs = []
var can_stick = true
var can_activate = true


func set_up():
	pass


func activate():
	if !my_shape.can_activate:
		return
	if !hand.get_node("CollisionShape2D").children_limbs.is_empty():
		for each in hand.get_node("CollisionShape2D").children_limbs:
			if !each.can_activate:
				return
	if global_position.distance_to($ResetPoint.global_position) <= 100.0:
		my_shape.can_activate = false
		hand.freeze = false
		var old_transform = hand.global_transform
		remove_child(hand)
		get_tree().get_first_node_in_group("world").add_child(hand)
		hand.global_transform = old_transform
		hand.apply_central_force(speed * (to_global($RayCast2D.target_position) - to_global($RayCast2D.position)).normalized())
		is_extending = true
		hand.get_node("CollisionShape2D").activate_children_limbs()


func reset():
	print("reset")
	get_parent().constant_force = Vector2.ZERO
	var old_transform = hand.global_transform
	get_tree().get_first_node_in_group("world").remove_child(hand)
	add_child(hand)
	hand.global_transform = old_transform
	is_grabbing = false
	hand.global_position = $ResetPoint.global_position
	hand.linear_velocity = Vector2.ZERO
	hand.angular_velocity = 0.0
	hand.freeze = true
	my_shape.can_activate = true


func pull_self_towards_item(delta):
	if !can_stick:
		return
	hand.freeze = true
	is_extending = false
	var direction = (hand.global_position - global_position)
	var force = 8.0
	print(get_parent())
	get_parent().constant_force = direction * force
	if get_parent().global_position.distance_to(hand.global_position) <= 250.0:
		reset()


func line_animation(delta):
	if global_position.x > hand.global_position.x:
		hand.get_node("AnimatedSprite2D").scale.x = 6
	else:
		hand.get_node("AnimatedSprite2D").scale.x = -6
	$Line2D.set_point_position(0, to_local(global_position))
	$Line2D.set_point_position(2, to_local(hand.global_position))
	var midpoint = Vector2(($Line2D.get_point_position(2).x - $Line2D.get_point_position(0).x)/2, ($Line2D.get_point_position(2).y - $Line2D.get_point_position(0).y)/2)
	$Line2D.set_point_position(1, midpoint)


func _process(delta):
	can_activate = my_shape.can_activate
	if get_parent().global_position.distance_to(hand.global_position) >= 8000.0:
		reset()

	line_animation(delta)

	if is_grabbing:
		pull_self_towards_item(delta)



func _on_hand_body_entered(body):
	if !body.is_in_group("cant_stick"):
		is_grabbing = true
