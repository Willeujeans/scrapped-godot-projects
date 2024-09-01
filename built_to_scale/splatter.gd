extends Node2D


@onready var grow = true
var size_factor = 1.0


func _ready():
	var my_circle = CircleShape2D.new()
	my_circle.set_radius(300.0 * (size_factor/2))
	$Area2D/CollisionShape2D.call_deferred("set_shape", my_circle)
	$Splat.scale *= size_factor
	$Explosion.scale *= size_factor
	$CPUParticles2D.scale *= size_factor
	$CPUParticles2D.modulate = modulate
	$CPUParticles2D.emitting = true
	get_tree().get_first_node_in_group("AnimationHandler").animate.connect(play_next_frame)
	$Splat.rotation_degrees = randf_range(-360, 360)
	set_splat_radius()
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.5, 1.1)
	$AudioStreamPlayer2D.play()


func set_splat_radius():
	$Area2D/CollisionShape2D.shape.radius = 1.0 * size_factor


func play_next_frame(current_frame):
	if current_frame == 0:
		$Splat.play("one")
	else:
		$Splat.play("two")


func _process(delta):
	if grow:
		if $Splat.scale.x < 2.5:
			$Splat.scale.x = lerp($Splat.scale.x, 2.0, 12.0 * delta)
			$Splat.scale.y = lerp($Splat.scale.y, 2.0, 10.0 * delta)
		else:
			grow = false


func _on_explosion_animation_finished():
	$Splat.visible = true
	$Timer.start()
	await $Timer.timeout
	$Area2D.queue_free()
