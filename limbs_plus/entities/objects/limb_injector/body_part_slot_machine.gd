extends Node2D

@export var body_parts: Array[PackedScene]
@export var key_label: PackedScene
@export var key_label_textures: Array[Texture2D]
var time_till_drop = 200.0
var current_time = 0.0
var letters = ["h", "j", "k", "l"]
var letter_i = 0


func _process(delta):
	if $RayCast2D.is_colliding():
		current_time += 1.0
	else:
		current_time = 0.0
	if current_time >= time_till_drop:
		drop()
		current_time = 0.0


func drop():
	$AnimationPlayer.play("new_animation")
	var body_part_position = $RayCast2D.get_collision_point()
	var body = $RayCast2D.get_collider().get_parent()
	var i = $RayCast2D.get_collider_shape()
	var shape = body.shape_owner_get_owner(i)
	var body_part = body_parts[0].instantiate()
	body_part.position = body.to_local(body_part_position)
	body.add_child(body_part)
	body_part.look_at(get_tree().get_first_node_in_group("player").global_position)
	body_part.set_up()
	if shape.is_in_group("can_hold_limb"):
		var remote_transform = RemoteTransform2D.new()
		remote_transform.set_update_rotation(false)
		if shape.my_old_parent:
			shape.my_old_parent.attatchment_point.add_child(remote_transform)
			shape.my_old_parent.children_limbs.append(body_part)
		else:
			shape.attatchment_point.add_child(remote_transform)
			shape.children_limbs.append(body_part)
		remote_transform.global_position = $RayCast2D.get_collision_point()
		remote_transform.set_remote_node(body_part.get_path())
	else:
		body_part.trigger_button = letters[letter_i]
		var key_label_instance = key_label.instantiate()
		key_label_instance.set_texture(key_label_textures[letter_i])
		body.add_child(key_label_instance)
		key_label_instance.position = body_part.position
		letter_i += 1
