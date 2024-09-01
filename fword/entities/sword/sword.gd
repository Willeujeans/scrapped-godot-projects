extends RigidBody2D

const MAX_SPEED = 1200.0
@export var dead_sword:PackedScene
@export var blade_visual_scene: Texture
@export var world_shader_scene: Shader
var player_camera: Camera2D
var has_shaken: bool = false
var being_held: bool = false
var hold_position: Vector2
var hold_linear_velocity: Vector2
var hold_angular_velocity: float
var impact_direction: int = 1
var is_upright: bool = false
var canBounce: bool = true
var is_stuck: bool = false
var impulse_strength: float = 700.0


func _ready():
	#player_camera = get_tree().get_nodes_in_group("main_camera")[0]
	impact_frame_lesser()
	$Timer/BounceActivation.start()
	$Timer/NoPlayerHit.start()
	await $Timer/BounceActivation.timeout
	$BounceArea/BounceShape.set_deferred("disabled", false)


func _process(delta):
	if rotation_degrees > 360.0:
		rotation_degrees = 360.0
	if is_stuck:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
		return
		
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
		
	if being_held:
		set_deferred("position", hold_position)
		set_deferred("linear_velocity", hold_linear_velocity)
		set_deferred("angular_velocity", hold_angular_velocity)


func _on_area_2d_body_entered(body):
	if body == self:
		return

	if body.is_class("TileMap"):
		stick(get_parent())
		return

	if body.is_in_group("unstickable") and body != $".":
		$Audio/ClinkSound.play()
		$Audio/ClunkSound.play()
		$Audio/BitExplosionAudio.play()
		return

	if body.is_class("RigidBody2D"):
		stick(body)
		return

	if body.is_class("CharacterBody2D"):
		#stick(body)
		return


func _on_edge_area_area_entered(area):
	if area.is_class("Area2D") and area.get_parent().is_in_group("stickable"):
		stick(area.get_parent())
		return


func stick(parent):
	if is_stuck:
		return
	is_stuck = true
	var dead_blade_instance = dead_sword.instantiate()
	var newPosition = position - parent.global_position
	parent.call_deferred("add_child",dead_blade_instance)
	dead_blade_instance.position = parent.to_local(position)
	dead_blade_instance.rotation = global_rotation - parent.global_rotation
	queue_free()


func create_blade_sprite(degree: float):
	var sprite = Sprite2D.new()
	sprite.set_material($Sprite.get_material())
	sprite.texture = blade_visual_scene
	sprite.scale = $Sprite.scale
	sprite.z_index = -2
	sprite.offset.y = -15.0
	sprite.position.y = 60
	sprite.set_rotation_degrees(impact_direction * -1 * degree)
	return sprite


func play_impact_sounds():
	$Audio/CutAudio.play()
	$Audio/ThudImpactFramesAudio.play()
	$Audio/BitExplosionAudio.play()


func impact_frame():
	var player_camera = get_tree().get_first_node_in_group("player_camera")
	player_camera.screen_shake(4.0, 4.0)
	$Timer/Impact.start()
	play_impact_sounds()
	hold_position = position
	hold_angular_velocity = angular_velocity
	hold_linear_velocity = linear_velocity
	being_held = true
	var blade_sprite_list = []
	if impact_direction != 0:
		var degree_amount = 0
		for _i in 6:
			degree_amount += 5
			blade_sprite_list.append(create_blade_sprite(degree_amount))
		for blade_sprite in blade_sprite_list:
			add_child(blade_sprite)
	await $Timer/Impact.timeout
	being_held = false
	blade_sprite_list.reverse()
	for blade_sprite in blade_sprite_list:
		$Timer/ImpactEnding.start()
		await $Timer/ImpactEnding.timeout
		blade_sprite.queue_free()


func impact_frame_lesser():
	$Timer/Impact.start()
	var blade_sprite_list = []
	if impact_direction != 0:
		var degree_amount: float = 0.0
		for _i in 9:
			degree_amount += 5.0
			blade_sprite_list.append(create_blade_sprite(degree_amount))
		for blade_sprite in blade_sprite_list:
			add_child(blade_sprite)
	await $Timer/Impact.timeout
	blade_sprite_list.reverse()
	for blade_sprite in blade_sprite_list:
		$Timer/ImpactEndingLesser.start()
		await $Timer/ImpactEndingLesser.timeout
		blade_sprite.queue_free()


func choose_randomly(list):
	return list[randi() % list.size()]


func _on_bounce_area_body_entered(body):
	if !$Timer/NoPlayerHit.is_stopped() and body.is_in_group("player"):
		return
		
	if body.is_in_group("sword") and is_upright:
		return
		
	if $Timer/BounceGrace.is_stopped() and body != self:
		$Timer/BounceGrace.start()
		being_held = false
		$Sprite.play("bounce")
		var true_rotation = rotation-(PI/2)
		var altered_rotation = true_rotation + ((PI/6) * impact_direction)
		var scalar = abs(linear_velocity.length() * 0.0015)
		if is_upright:
			if body.is_class("CharacterBody2D"):
				linear_velocity.x = body.velocity.x / 2.0
			linear_velocity.y *= -1.2
		else:
			linear_velocity = Vector2.ZERO
			apply_central_impulse(Vector2(
					scalar * impulse_strength * cos(altered_rotation),
					scalar * impulse_strength * sin(altered_rotation)
			))
			angular_velocity *= 0.98
			impulse_strength *= 0.5

# we need to get the absolute parent of the scene
func get_root_of_scene():
	var current_root = self
	while current_root.get_parent() != null:
		current_root = current_root.get_parent()
		if current_root.is_class("CharacterBody2D") or current_root.is_class("RigidBody2D"):
			return current_root
	return current_root



func _on_bounce_area_area_entered(area):
	if !area.get_parent().is_in_group("stickable"):
		return
	if !$Timer/NoPlayerHit.is_stopped() and area.get_parent().is_in_group("player"):
		return
		
	if area.get_parent().is_in_group("sword") and is_upright:
		return
		
	if $Timer/BounceGrace.is_stopped() and area.get_parent() != self:
		$Timer/BounceGrace.start()
		being_held = false
		$Sprite.play("bounce")
		var true_rotation = rotation-(PI/2)
		var altered_rotation = true_rotation + ((PI/6) * impact_direction)*-1
		var scalar = abs(linear_velocity.length() * 0.0015)
		if is_upright:
			if area.get_parent().is_class("CharacterBody2D"):
				print("parentVel: ")
				print(area.get_parent().velocity.x)
				linear_velocity.x = area.get_parent().velocity.x
				print("childVel: ")
				print(linear_velocity.x)
			linear_velocity.y *= -1.2
		else:
			linear_velocity = Vector2.ZERO
			apply_central_impulse(Vector2(
					scalar * impulse_strength * cos(altered_rotation),
					scalar * impulse_strength * sin(altered_rotation)
			))
			apply_central_impulse(Vector2(0,-1000))
			angular_velocity *= 0.98
			impulse_strength *= 0.5
