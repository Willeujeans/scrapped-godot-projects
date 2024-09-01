extends Node2D

@export var body: NodePath
@export var delay_between_activation = 1.0
@export var attachment_point: NodePath
@export var activation_node: NodePath
@export var can_have_children: bool = true
var parent_limb
var children_limbs = []
var trigger_button = ""
var ready_to_deactivate = false
var is_active = false


func get_attachment_point():
	return get_node(attachment_point)


func set_up():
	print("setting up")
	get_node(activation_node).set_up()


func activate():
	if is_active:
		return
	is_active = true
	get_node(activation_node).activate()
	activate_children()


func activate_children():
	if children_limbs.is_empty():
		return
	var new_timer = Timer.new()
	add_child(new_timer)
	new_timer.set_wait_time(delay_between_activation)
	new_timer.start()
	await new_timer.timeout
	for child_limb in children_limbs:
		child_limb.activate()
	new_timer.queue_free()
