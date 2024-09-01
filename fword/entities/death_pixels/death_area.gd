extends Area2D

@onready var parent = get_parent()
@export var death_cube_shader_material: Shader
@export var death_pixels_scene: PackedScene
@export var death_sound: AudioStreamWAV

func _ready():
	$DeathSound.set_stream(death_sound)


func _on_area_entered(area):
	if area.is_in_group("entityEdge"):
		area.get_parent().impact_frame()
		$DeathDelay.start()
		await $DeathDelay.timeout
		kill_self()


func kill_self():
	set_deferred("freeze", true)
	parent.visible = false
	parent.get_node("CollisionShape2D").set_deferred("disabled", true)
	spawn_death_cubes()
	if parent.is_in_group("enemy"):
		get_tree().get_nodes_in_group("level")[0].check_for_enemies()
	if $DeathSound.get_stream():
		$DeathSound.play()
	else:
		parent.queue_free()

func spawn_death_cubes():
	var dead_square_spawner = death_pixels_scene.instantiate()
	dead_square_spawner.position = parent.position
	dead_square_spawner.set_cube_count(3)
	dead_square_spawner.set_my_shader(death_cube_shader_material)
	parent.get_parent().call_deferred("add_child", dead_square_spawner)


func _on_death_sound_finished():
	parent.queue_free()
