extends CharacterBody2D
@export var moves_vertically = false
@export var hand_home_spot: NodePath
@export var direction = 1
@export var wizard_hand: PackedScene
var detection_bank = 3.1
var speed = 20.0
var is_detecting = false
var target = null
var dict_rays = {}
enum states {
	IDLE,
	SEARCHING,
	REACHING
	}
@onready var state = states.SEARCHING

func _ready():
	if moves_vertically:
		$CollisionShape2D.rotation = deg_to_rad(90.0)


func _process(delta):
	match state:
		states.IDLE:
			$innerRing.enabled = false
			return
		states.SEARCHING:
			if $CollisionShape2D/RightRayCast.is_colliding():
				if direction != -1:
					bounce()
				direction = -1
			if $CollisionShape2D/LeftRayCast.is_colliding():
				if direction != 1:
					bounce()
				direction = 1
			if direction > 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			if moves_vertically:
				velocity.y = speed * direction
			else:
				velocity.x = speed * direction
			move_and_slide()
		states.REACHING:
			summon_hand()
			state = states.IDLE
	track_targets()
	if is_detecting:
		if $innerRing.color.g > 0.0:
			$innerRing.color.g -= 4.0 * delta
		if $innerRing.color.b > 0.0:
			$innerRing.color.b -= 4.0 * delta
		if detection_bank > 0.0:
			detection_bank -= 2.0 * delta
	if !is_detecting:
		if $innerRing.color.g < 1.0:
			$innerRing.color.g += 1.0 * delta
		if $innerRing.color.b < 1.0:
			$innerRing.color.b += 1.0 * delta
		if detection_bank < 3.0:
			detection_bank += 1.5 * delta
			
	if detection_bank > 3.0:
		detection_bank = 3.0
	if detection_bank < 0.0:
		detection_bank = 0.0


func bounce():
	if $innerRing.enabled:
		$innerRing.enabled = false
		$Area2D/CollisionShape2D.disabled = true
		$AnimatedSprite2D.play("blink")
		$SwitchOnPlayer.play()
		$HummPlayer.max_distance = 1
		$LineGen.visible = false
	else:
		$innerRing.enabled = true
		$Area2D/CollisionShape2D.disabled = false
		$AnimatedSprite2D.play("default")
		$SwitchOffPlayer.play()
		$HummPlayer.max_distance = 500
		$LineGen.visible = true


func track_targets():
	is_detecting = false
	for each in $Area2D.get_overlapping_areas():
		if each.is_in_group("target"):
			dict_rays[each].target_position = self.to_local(each.global_position)
			if dict_rays[each].get_collider() == each and state == states.SEARCHING:
				is_detecting = true
				if each.get_parent().is_in_group("player"):
					get_tree().get_first_node_in_group("music").set_player_in_danger()
				if detection_bank <= 0.0:
					if get_tree().get_nodes_in_group("hand").is_empty():
						target = each.get_parent()
						state = states.REACHING


func summon_hand():
	detection_bank = 3.0
	var wizard_hand_instance = wizard_hand.instantiate()
	wizard_hand_instance.finished_throwing.connect(start_searching_again)
	wizard_hand_instance.position = Vector2(position.x, position.y - 60.0)
	
	wizard_hand_instance.current_target = target
	get_parent().call_deferred("add_child", wizard_hand_instance)
	wizard_hand_instance.home_position = get_node(hand_home_spot).global_position


func start_searching_again():
	print("searching again")
	$innerRing.enabled = true
	state = states.SEARCHING


func _on_area_2d_area_entered(area):
	if area.is_in_group("target"):
		var new_ray: RayCast2D = RayCast2D.new()
		new_ray.set_collision_mask_value(1, false)
		new_ray.set_collision_mask_value(3, true)
		new_ray.collide_with_areas = true
		new_ray.collide_with_bodies = true
		new_ray.hit_from_inside = true
		call_deferred("add_child", new_ray)
		dict_rays[area] = new_ray


func _on_area_2d_area_exited(area):
	if area.is_in_group("target"):
		dict_rays[area].queue_free()
		dict_rays.erase(area)
