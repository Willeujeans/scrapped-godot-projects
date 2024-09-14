extends Node2D

@export var color_pal: Array[Vector3] = []
@export var transition_scene: PackedScene
@onready var can_restart = true
var escape_time_bank = 1.0


func _ready():
	print(name)
	$SceneChangeNode.next_scene = load("res://menus/level_select/level_selection_carousell.tscn")
	var color_string = get_children()[0].name
	var colors_string_as_list = color_string.split("_")
	var color_list = []
	for each in colors_string_as_list:
		color_list.append(Color(each))
	$Squid.color_list = color_list


func _process(delta):
	if Input.is_action_just_pressed("reset") and $TimerReset.is_stopped() and can_restart:
		restart()
	if Input.is_action_pressed("escape"):
		escape_time_bank -= 1.0 * delta
		$UI/Control/HoldForLevelSelect.visible = true
	if escape_time_bank <= 0:
			$SceneChangeNode.go_next_scene()
	if Input.is_action_just_released("escape") and escape_time_bank > 0:
		escape_time_bank = 5.0
		$UI/Control/HoldForLevelSelect.visible = false


func restart():
	can_restart = false
	var transition = transition_scene.instantiate()
	transition.play_speed = 2.0
	transition.connect("total_eclipse", func(): finish_restart())
	get_parent().add_child(transition)


func finish_restart():
	var parent_node = get_parent()
	parent_node.remove_child(self)
	var scene = load(self.get_scene_file_path()).instantiate()
	parent_node.call_deferred("add_child", scene)
	queue_free()
