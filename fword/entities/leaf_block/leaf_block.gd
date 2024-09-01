extends StaticBody2D
var is_dead: bool = false

func _ready():
	var array: Array[int] = [0, 90, 180, -90, -180]
	$Sprite2D.rotation = deg_to_rad(array.pick_random())


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("sword"):
		kill_self(0.0)

func kill_self(time):
	if time > 0.0:
		$DeathTimer.wait_time = time
		$DeathTimer.start()
		await $DeathTimer.timeout
	is_dead = true
	$Sprite2D.visible = false
	$CPUParticles2D.set_emitting(true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()
	for each in $Area2D2.get_overlapping_areas():
		if each.is_in_group("leaves"):
			if !each.get_parent().is_dead:
				each.get_parent().kill_self(0.5)
	await $Timer.timeout
	queue_free()
