extends Node2D

signal level_complete

@export var back_scene: PackedScene
@export var transition_scene: PackedScene
@export var ding_sound : PackedScene
@export var continue_prompt: PackedScene
@export var three_star: int = 4
@export var star_spread: int = 2
@onready var two_star: int = three_star + star_spread
@onready var one_star: int = two_star + star_spread

@onready var can_continue: bool = false
@onready var current_ding_pitch: float = 0.7
@onready var rng = RandomNumberGenerator.new()
@onready var star_count: int = 3
@onready var can_restart: bool = true

var best_star_count: int = 0
var death_count: int = 0


func _ready():
	level_complete.connect(completed_level)
	$PlayerBody.sword_thrown.connect(update_star_count)
	$CanvasLayer/ThrowTracker.set_star_numbers(three_star, two_star, one_star)


func _process(delta):
	if Input.is_action_just_pressed("restart") and can_restart:
		get_tree().get_first_node_in_group("player").kill_self()


func check_for_enemies():
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	if all_enemies.size() <= 1:
		level_complete.emit()


func prompt_continue():
	var continue_prompt_instance = continue_prompt.instantiate()
	add_child(continue_prompt_instance)
	await get_tree().create_timer(0.5).timeout
	can_continue = true


func update_star_count(in_thrown_swords):
	$CanvasLayer/ThrowTracker.drop_element()
	if in_thrown_swords > three_star:
		star_count = 2
		if in_thrown_swords > two_star:
			star_count = 1
			if in_thrown_swords > one_star:
				star_count = 0


func completed_level():
	$Door.activate()


func increase_ding_pitch():
	current_ding_pitch += 0.1


func reset_ding_pitch():
	current_ding_pitch = 0.7


func play_ding():
	var ding = ding_sound.instantiate()
	ding.pitch_scale = current_ding_pitch
	add_child(ding)
	increase_ding_pitch()


func restart():
	can_restart = false
	var transition = transition_scene.instantiate()
	transition.connect("total_eclipse", func(): finish_restart())
	get_parent().add_child(transition)


func finish_restart():
	var scene = load(self.get_scene_file_path()).instantiate()
	get_parent().call_deferred("add_child", scene)
	queue_free()


func _on_area_2d_body_entered(body):
	if !body.is_class("CharacterBody2D"):
		return
	$SceneChangeNode.go_next_scene()
