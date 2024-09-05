extends RigidBody2D
@export var ink_size = 1.0
@export var force = 6.0
@export var ink_splatter_scene: PackedScene
@export var ink_filled_anim: Resource
@onready var splatted = false
var can_explode = false
var instance_number = 0


func _ready():
	get_tree().get_first_node_in_group("AnimationHandler").animate.connect(play_next_frame)
	var my_circle = CircleShape2D.new()
	my_circle.set_radius(60.0)
	$HitDetection/CollisionShape2D.call_deferred("set_shape", my_circle)
	
	var my_other_circle = CircleShape2D.new()
	my_other_circle.set_radius(350.0)
	$ExplosionDetection/CollisionShape2D.call_deferred("set_shape", my_other_circle)
	$AnimatedSprite2D.modulate = Color(randf(), randf(), randf(), 1.0)


func increase_ink_size(sprite_scale, collision_size, explosion_size, explosion_force):
	if ink_size >= 4:
		return
	var ink_scale = 0.25
	ink_size += 1
	$AnimatedSprite2D.scale += sprite_scale * ink_scale
	$HitDetection/CollisionShape2D.shape.radius += collision_size * ink_scale
	$ExplosionDetection/CollisionShape2D.shape.radius += explosion_size * ink_scale
	force += explosion_force * (ink_scale/2)
	

func explode():
	for each in $ExplosionDetection.get_overlapping_bodies():
		if each.is_class("RigidBody2D"):
			var direction = (each.global_position - self.global_position).normalized()
			var distance = self.global_position.distance_to(each.global_position)
			var inverted_distance = max(1.0, $ExplosionDetection/CollisionShape2D.shape.radius - distance)
			var stored_length = each.linear_velocity.length()
			var magnitude = (force * inverted_distance) + (stored_length/2)
			each.linear_velocity = Vector2.ZERO
			each.apply_central_impulse(direction * magnitude)
	
	if not splatted:
		splatted = true
		var ink_splatter_instance = ink_splatter_scene.instantiate()
		ink_splatter_instance.size_factor = ink_size
		ink_splatter_instance.modulate = $AnimatedSprite2D.get_modulate()
		get_parent().call_deferred("add_child", ink_splatter_instance)
		ink_splatter_instance.global_position = self.global_position
		queue_free()


func _on_hit_detection_body_entered(body):
	if body.is_class("TileMap"):
		call_deferred("set_freeze_enabled", true)
		$AnimatedSprite2D.sprite_frames = ink_filled_anim
		can_explode = true


func _process(delta):
	for body in $HitDetection.get_overlapping_bodies():
		if body.is_in_group("player") and can_explode:
			explode()


func _on_hit_detection_area_entered(area):
	if area.is_in_group("ink"):
		var body = area.get_parent()
		if instance_number > body.instance_number:
			body.increase_ink_size(body.get_node('AnimatedSprite2D').scale, body.get_node("HitDetection").get_node('CollisionShape2D').shape.radius, body.get_node("ExplosionDetection").get_node("CollisionShape2D").shape.radius, body.force)
			queue_free()


func play_next_frame(current_frame):
	if current_frame == 0:
		$AnimatedSprite2D.play("one")
	else:
		$AnimatedSprite2D.play("two")
