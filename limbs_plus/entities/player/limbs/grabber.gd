extends Node2D
@export var hand_scene: PackedScene
@onready var parent = get_parent()
var hand
var has_hand: bool = false
var can_trigger = true


func set_up():
	print("set up")


func activate():
	deactivate()
	$Sprite2D.visible = false
	hand = hand_scene.instantiate()
	call_deferred("add_child", hand)
	hand.is_extending = true
	remove_hand()
	has_hand = true


func deactivate():
	$Sprite2D.visible = true
	get_parent().constant_force = Vector2.ZERO
	if has_hand:
		hand.queue_free() 
	has_hand = false


func remove_hand():
	call_deferred("remove_child", hand)
	get_tree().get_first_node_in_group("world").call_deferred("add_child", hand)
	hand.position = to_global(hand.position)
	hand.rotation = hand.global_rotation


func _process(delta):
	$Line2D.set_point_position(0, to_local(global_position))
	if has_hand:
		$Line2D.set_point_position(2, to_local(hand.global_position))
		#if global_position.distance_to(hand.global_position) >= 1000.0:
			#deactivate()
	else:
		$Line2D.set_point_position(2, to_local(global_position))
	var midpoint = Vector2(($Line2D.get_point_position(2).x - $Line2D.get_point_position(0).x)/2, ($Line2D.get_point_position(2).y - $Line2D.get_point_position(0).y)/2)
	$Line2D.set_point_position(1, midpoint)
