extends Node2D

@export var transition_scene: PackedScene
@onready var can_restart = true
var escape_time_bank = 1.0


func _ready():
	$SceneChangeNode.next_scene = load("res://menus/level_select/level_selection_carousell.tscn")


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
	var scene = load(self.get_scene_file_path()).instantiate()
	get_parent().call_deferred("add_child", scene)
	queue_free()
