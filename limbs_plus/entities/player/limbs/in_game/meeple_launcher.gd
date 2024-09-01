extends Node2D
@export var force = 60.0
@export var self_force = 1.0
var is_going_home = false
var last_position
var meeple_out = false


func set_up():
	$Holder.set_node_a($"..".get_parent().get_path())
	$HolderSpring.set_node_a($"..".get_parent().get_path())
	reset_meeple()


func reset_meeple():
	$Meeple.set_collision_mask_value(5, false)
	print("reset")
	meeple_out = false
	$Meeple.is_attached = true
	is_going_home = false
	$Meeple.linear_velocity = Vector2.ZERO
	$Meeple.global_position = $MeepleSpot.global_position
	$Holder.set_node_b($Meeple.get_path())
	$HolderSpring.set_node_b($Meeple.get_path())
	$"..".is_active = false


func activate():
	print("activated")
	$Holder.set_node_b("")
	$HolderSpring.set_node_b("")
	$Meeple.is_attached = false
	var direction = (to_global($RayCast2D.target_position) - $RayCast2D.global_position).normalized()
	for each in $"..".children_limbs:
		force *= 1.1
	$Meeple.apply_central_impulse(direction * force)
	if $RayCast2D.is_colliding():
		var opposite_direction = ($RayCast2D.global_position - to_global($RayCast2D.target_position)).normalized()
		$"..".get_parent().apply_central_impulse(opposite_direction * self_force)
	$Meeple.set_collision_mask_value(5, true)
	$ActivationSound.pitch_scale = randf_range(1.0, 1.3)
	$ActivationSound.play()
	$ActivationSound2.pitch_scale = randf_range(0.9, 1.3)
	$ActivationSound2.play()
	$TimeTillMeeplePulled.start()
	$Timer.start()
	await $Timer.timeout
	meeple_out = true


func _on_time_till_meeple_pulled_timeout():
	if meeple_out:
		is_going_home = true
		last_position = $Meeple.global_position
		play_coming_back_sounds()

func play_coming_back_sounds():
	$Meeple/ComingBack.pitch_scale = randf_range(1.1, 1.5)
	$Meeple/ComingBack.play()
	$Meeple/ComingBackBetween.start()
	await $Meeple/ComingBackBetween.timeout
	if is_going_home:
		play_coming_back_sounds()

func _physics_process(delta):
	if $Meeple.is_grabbed:
		return
	if $Meeple.global_position.distance_to(global_position) >= 1000.0:
		print("reset due to distance or velocity being too high")
		reset_meeple()
	if meeple_out:
		if $Meeple.global_position.distance_to($"..".get_parent().global_position) <= 25.0:
			print("reset because we are close enough to home")
			reset_meeple()
	if is_going_home:
		if $Meeple.global_position.distance_to(last_position) <= 0.01:
			$Meeple.apply_central_force(Vector2(0.0, -1600.0))
		else:
			var direction = (global_position - $Meeple.global_position).normalized()
			$Meeple.apply_central_force(direction * 100.0)
		last_position = $Meeple.global_position

