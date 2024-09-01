extends Node2D
@export var body_part_images: Array[Texture2D]
@export var orb_limb: PackedScene
@export var body_parts: Array[PackedScene]
@export var key_label: PackedScene
@export var key_label_textures: Array[Texture2D]
@export var key_binding_scene: PackedScene
@export var limb_count = 4
@export var first_limb = -1
@onready var player = get_tree().get_first_node_in_group("player")
@onready var attachment_parents = {
	"h": player,
	"j": player,
	"k": player,
	"l": player
	}
var orb_array = []
var waiting_for_key = false
var time_till_drop = 100.0
var current_time = 0.0
var loaded_index = 0
var mouth_loaded = false
var asking = false
@onready var key_binding_instance = $Control
var moving_to_point_1 = false
var moving_to_point_2 = false
var current_orb


func _ready():
	populate_orb()


func _process(delta):
	if mouth_loaded and player.global_position.distance_to($RayCast2D.global_position) <= 60.0:
		waiting_for_key = true
	else:
		waiting_for_key = false

	if $RayCast2D.is_colliding():
		load_next_limb_orb()
	if moving_to_point_1:
		current_orb.get_node("CollisionShape2D").disabled = true
		current_orb.linear_velocity = Vector2.ZERO
		current_orb.global_position = lerp(current_orb.global_position, $Point1.global_position,delta)
		if current_orb.global_position.distance_to($Point1.global_position) <= 30.0:
			moving_to_point_1 = false
			moving_to_point_2 = true
	if moving_to_point_2:
		current_orb.get_node("CollisionShape2D").disabled = true
		current_orb.linear_velocity = Vector2.ZERO
		current_orb.global_position = lerp(current_orb.global_position, $Point2.global_position,delta)
		if current_orb.global_position.distance_to($Point2.global_position) <= 5.0:
			moving_to_point_2 = false
	if waiting_for_key:
		key_binding_instance.visible = true
		if Input.is_action_just_pressed("h"):
			add_limb(body_parts[loaded_index], "h")
		elif Input.is_action_just_pressed("j"):
			add_limb(body_parts[loaded_index], "j")
			return
		elif Input.is_action_just_pressed("k"):
			add_limb(body_parts[loaded_index], "k")
			return
		elif Input.is_action_just_pressed("l"):
			add_limb(body_parts[loaded_index], "l")
			return
	else:
		key_binding_instance.visible = false


func populate_orb():
	for each in limb_count:
		var created_orb = create_orb_limb()
		orb_array.append(created_orb)
		call_deferred("add_child", created_orb)
		$TimeBetweenOrbSpawns.start()
		await $TimeBetweenOrbSpawns.timeout


func create_orb_limb():
	var part_orb_index = body_parts.find(body_parts.pick_random())
	if first_limb != -1:
		part_orb_index = first_limb
	var orb = orb_limb.instantiate()
	orb.index = part_orb_index
	orb.get_node("Sprite2D").set_texture(body_part_images[part_orb_index])
	orb.position = $Marker2D.position
	return orb


func add_limb(limb: PackedScene, key: String):
	player.can_activate_limbs = false
	waiting_for_key = false
	var limb_instance = limb.instantiate()
	limb_instance.trigger_button = key
	if limb_instance.trigger_button == "h":
		limb_instance.set_modulate(Color(1.0, 0.2, 0.2, 1.0))
		get_tree().get_first_node_in_group("key_visible").show_key("h")
	if limb_instance.trigger_button == "j":
		limb_instance.set_modulate(Color(0.6, 0.9, 0.0, 1.0))
		get_tree().get_first_node_in_group("key_visible").show_key("j")
	if limb_instance.trigger_button == "k":
		limb_instance.set_modulate(Color(0.25, 0.5, 1.0, 1.0))
		get_tree().get_first_node_in_group("key_visible").show_key("k")
	if limb_instance.trigger_button == "l":
		limb_instance.set_modulate(Color(0.8, 0.5, 1.0, 1.0))
		get_tree().get_first_node_in_group("key_visible").show_key("l")
	
	var attachment_marker = get_tree().get_first_node_in_group(limb_instance.trigger_button)
	var body_to_attach_to = attachment_parents[limb_instance.trigger_button]
	if !body_to_attach_to.is_in_group("player"):
		if !body_to_attach_to.get_parent().get_parent().can_have_children:
			return
	body_to_attach_to.add_child(limb_instance)
	if body_to_attach_to.is_in_group("player"):
		limb_instance.global_position = attachment_marker.global_position
	else:
		limb_instance.global_position = limb_instance.get_attachment_point().global_position
	
	limb_instance.look_at(player.global_position)
	limb_instance.set_up()
	
	attachment_marker.global_position = limb_instance.get_attachment_point().global_position
	
	attachment_parents[limb_instance.trigger_button] = limb_instance.get_node(limb_instance.body)
	limb_instance.parent_limb = null
	mouth_loaded = false
	$Pop.play()
	
	if limb_instance.can_have_children == false:
		get_tree().get_first_node_in_group(limb_instance.trigger_button).visible = false
		get_tree().get_first_node_in_group(str(limb_instance.trigger_button) + "_key").visible = false
	
	$TimeTillAct.start()
	await $TimeTillAct.timeout
	$AnimatedSprite2D.play("default")
	player.can_act = true
	player.can_activate_limbs = true
	$RayCast2D.enabled = true


func load_next_limb_orb():
	if !orb_array.is_empty():
		current_orb = orb_array.pick_random()
		moving_to_point_1 = true
		$RayCast2D.enabled = false


func _on_eater_trigger_area_entered(area):
	if area.get_parent().is_in_group("orb"):
		$Chomp.play()
		$GlassBreak.play()
		orb_array.remove_at(orb_array.find(area.get_parent()))
		loaded_index = area.get_parent().index
		area.get_parent().queue_free()
		$AnimatedSprite2D.play("bite")
		mouth_loaded = true
