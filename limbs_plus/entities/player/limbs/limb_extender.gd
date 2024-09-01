extends Node2D
@onready var extension = $CollisionShape2D
@onready var front_ray = $FrontRay
var speed = 5.0
var extending = false
var retracting = false
var children_limbs = []
var trigger_button = ""
@onready var can_activate = true
@onready var attatchment_point = $AttatchmentPoint


func set_up():
	var old = extension.get_global_transform()
	remove_child(extension)
	get_parent().add_child(extension)
	extension.set_global_transform(old)


func activate():
	if !can_activate:
		return
	can_activate = false
	if !extending and !retracting:
		extending = true
	activate_children_limbs()


func activate_children_limbs():
	for each in children_limbs:
		$TriggerChildrenDelay.start()
		await $TriggerChildrenDelay.timeout
		each.activate()


func _process(delta):
	$Line2D.set_point_position(1, to_local($AttatchmentPoint.global_position))
	extension.shape.size.x = $AttatchmentPoint.global_position.distance_to(self.global_position)
	if extending:
		if $Line2D.width > 20.0:
			$Line2D.width -= 1.0
		extension.global_position = lerp(extension.global_position, to_global($FrontRay.target_position/2), delta * speed * 2)
		$AttatchmentPoint.global_position = lerp($AttatchmentPoint.global_position, to_global($FrontRay.target_position), delta * speed)
		if $AttatchmentPoint.global_position.distance_to(to_global($FrontRay.target_position)) <= 0.1:
			extending = false
			retracting = true
	if retracting:
		if $Line2D.width < 60.0:
			$Line2D.width += 1.0
		extension.global_position = lerp(extension.global_position, $FrontRay.global_position, delta * speed * 2)
		$AttatchmentPoint.global_position = lerp($AttatchmentPoint.global_position, $FrontRay.global_position, delta * speed)
		if $AttatchmentPoint.global_position.distance_to($FrontRay.global_position) <= 0.1:
			retracting = false
			can_activate = true
