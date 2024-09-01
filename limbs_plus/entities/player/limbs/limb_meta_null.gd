extends CollisionShape2D

@onready var my_old_parent = null
@onready var attatchment_point = $"../AttatchmentPoint"
var children_limbs = []
var can_activate = true

func activate_children_limbs():
	for each in children_limbs:
		$TriggerChildrenDelay.start()
		await $TriggerChildrenDelay.timeout
		each.activate()
