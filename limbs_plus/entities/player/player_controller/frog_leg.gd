# Should push objects if it can!

extends CollisionShape2D
var scalar = 1000.0
@onready var ray = $RayCast2D
var trigger_button = ""
@onready var my_old_parent = null
@onready var attatchment_point = $AttatchmentPoint
var children_limbs = []
var can_activate = true


func _ready():
	ray.add_exception(get_parent())


func set_up():
	print("set up")


func activate():
	if !can_activate:
		return
	if !children_limbs.is_empty():
		for each in children_limbs:
			if !each.can_activate:
				return
	can_activate = false
	$AnimatedSprite2D.play("active")
	$AttatchmentPoint.position = $RayCast2D.target_position
	if ray.is_colliding():
		var impulse = (ray.global_position - to_global(ray.target_position)).normalized()
		get_parent().apply_central_impulse(scalar * impulse)
	activate_children_limbs()


func activate_children_limbs():
	for each in children_limbs:
		$TriggerChildrenDelay.start()
		await $TriggerChildrenDelay.timeout
		each.activate()


func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("default")
	$AttatchmentPoint.position = $RayCast2D.position
	can_activate = true
