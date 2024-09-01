extends CollisionPolygon2D

var trigger_button = ""
@onready var my_old_parent = null
@onready var attatchment_point = $AttatchmentPoint
var children_limbs = []
var can_activate = true


func set_up():
	pass


func activate():
	if !can_activate:
		return
	if !children_limbs.is_empty():
		for each in children_limbs:
			if !each.can_activate:
				return
	can_activate = false
	activate_children_limbs()
	can_activate = true


func activate_children_limbs():
	for each in children_limbs:
		$TriggerChildrenDelay.start()
		await $TriggerChildrenDelay.timeout
		print(each)
		each.activate()
