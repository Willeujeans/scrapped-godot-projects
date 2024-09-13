extends RigidBody2D
@export var ink_size = 1.0
@onready var force = 1200.0
@export var ink_splatter_scene: PackedScene
@onready var splatted = false
var can_explode = false
var instance_number = 0


func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "scale", Vector2($AnimatedSprite2D.scale.x + 2, $AnimatedSprite2D.scale.y + 2), 0.8).set_trans(Tween.TRANS_ELASTIC)
	
	get_tree().get_first_node_in_group("AnimationHandler").animate.connect(play_next_frame)
	var hit_circle = CircleShape2D.new()
	hit_circle.set_radius(60.0)
	$HitDetection/CollisionShape2D.call_deferred("set_shape", hit_circle)
	
	var explosion_circle = CircleShape2D.new()
	explosion_circle.set_radius(400.0)
	$ExplosionDetection/CollisionShape2D.call_deferred("set_shape", explosion_circle)
	
	var ink_circle = CircleShape2D.new()
	ink_circle.set_radius(60.0)
	$InkDetection/CollisionShape2D.call_deferred("set_shape", ink_circle)
	
	modulate = Color.from_hsv(randf_range(0.0, 1.0), 1.0, 1.0, 1.0)


func increase_ink_size(sprite_scale, collision_size, explosion_size, explosion_force, ink_color):
	if ink_size >= 3:
		return
	var ink_scale = 1.5
	ink_size += 1
	$AnimatedSprite2D.scale += sprite_scale * ink_scale
	$HitDetection/CollisionShape2D.shape.radius += collision_size * ink_scale
	$ExplosionDetection/CollisionShape2D.shape.radius += explosion_size * ink_scale
	force += (explosion_force * ink_scale)
	modulate = Color((modulate.r/2) + (ink_color.r/2), (modulate.g/2) + (ink_color.g/2),(modulate.b/2) + (ink_color.b/2))
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "scale", Vector2($AnimatedSprite2D.scale.x + 2, $AnimatedSprite2D.scale.y + 2), 0.8).set_trans(Tween.TRANS_ELASTIC)


func explode():
	for each in $ExplosionDetection.get_overlapping_bodies():
		if each.is_class("RigidBody2D"):
			var direction = (each.global_position - Vector2(self.global_position.x, self.global_position.y + 100.0 * ink_size)).normalized()
			var distance = self.global_position.distance_to(each.global_position)
			var inverted_distance = max(1.0, $ExplosionDetection/CollisionShape2D.shape.radius - distance)
			inverted_distance = $ExplosionDetection/CollisionShape2D.shape.radius
			var stored_length = each.linear_velocity.length()
			var magnitude = (force + (stored_length/1.5))
			each.linear_velocity = Vector2.ZERO
			var vector = direction * magnitude
			each.apply_central_impulse(vector)

	if not splatted:
		$InkDetection.queue_free()
		$HitDetection.queue_free()
		$AnimatedSprite2D.visible = false
		splatted = true
		var ink_splatter_instance = ink_splatter_scene.instantiate()
		ink_splatter_instance.size_factor = ink_size
		ink_splatter_instance.modulate = self.get_modulate()
		get_parent().call_deferred("add_child", ink_splatter_instance)
		ink_splatter_instance.global_position = self.global_position


func fizzle():
	if not splatted:
		call_deferred("set_freeze_enabled", true)
		$InkDetection.queue_free()
		$HitDetection.queue_free()
		$AnimatedSprite2D.visible = false
		splatted = true
		$Fizzle.emitting = true


func _on_hit_detection_body_entered(body):
	if not body.is_in_group("player"):
		explode()


func play_next_frame(current_frame):
	if current_frame == 0:
		$AnimatedSprite2D.play("one")
	else:
		$AnimatedSprite2D.play("two")


func _on_ink_detection_area_entered(area):
	if area.is_in_group("ink"):
		var body = area.get_parent()
		if ink_size < body.ink_size:
			body.get_node("AudioStreamPlayer2D").play()
			body.increase_ink_size(self.get_node('AnimatedSprite2D').scale, self.get_node("HitDetection").get_node('CollisionShape2D').shape.radius, self.get_node("ExplosionDetection").get_node("CollisionShape2D").shape.radius, self.force, modulate)
			queue_free()
		elif ink_size == body.ink_size:
			if instance_number > body.instance_number:
				body.get_node("AudioStreamPlayer2D").play()
				body.increase_ink_size(self.get_node('AnimatedSprite2D').scale, self.get_node("HitDetection").get_node('CollisionShape2D').shape.radius, self.get_node("ExplosionDetection").get_node("CollisionShape2D").shape.radius, self.force, modulate)
				queue_free()


func _on_till_explode_timeout():
	if $HitDetection/CollisionShape2D:
		$HitDetection/CollisionShape2D.call_deferred("set_disabled", false)
	if $InkDetection/CollisionShape2D:
		$InkDetection/CollisionShape2D.call_deferred("set_disabled", false)


func _physics_process(_delta):
	if ink_size > 1:
		var direction = get_tree().get_first_node_in_group("player").global_position - global_position
		var to_player_force = 15.0
		apply_central_force(direction * to_player_force)
		
