extends Node2D

@onready var can_restart = true
@export var transition_scene: PackedScene


func _ready():
	$SceneChangeNode.next_scene = load("res://menus/level_select/level_selection.tscn")


func _process(delta):
	if Input.is_action_just_pressed("reset") and $TimerReset.is_stopped() and can_restart:
		restart()


func restart():
	can_restart = false
	var transition = transition_scene.instantiate()
	transition.connect("total_eclipse", func(): finish_restart())
	get_parent().add_child(transition)


func finish_restart():
	var scene = load(self.get_scene_file_path()).instantiate()
	get_parent().call_deferred("add_child", scene)
	queue_free()
