extends Node2D

signal finished_throwing

var current_target
@export var maximum_distance = 1500.0
@onready var state = states.REACHING
var starting_position = Vector2(0,0)
var home_position

enum states {
	IDLE,
	SEARCHING,
	REACHING,
	GRABBING,
	THROWING,
	RETREAT
	}

func _ready():
	starting_position = home_position
	starting_position.y -= 100.0
	
func _process(delta):
	if current_target.is_in_group("player"):
		get_tree().get_first_node_in_group("music").set_player_in_danger()
	match state:
		states.IDLE:
			return
		states.REACHING:
			if global_position.distance_to(home_position) >= maximum_distance:
				print("TOO FAR")
				state = states.RETREAT
				finished_throwing.emit()
				return
			$AnimatedSprite2D.rotation = 0.0
			$AnimatedSprite2D.play("default")
			move_hand_towards_target(delta)
		states.GRABBING:
			grasping(delta)
			go_home(delta)
		states.THROWING:
			throw_target()
		states.RETREAT:
			retreat(delta)


func grasping(delta):
	if current_target.is_in_group("player"):
		current_target.set_collision_layer_value(1, false)
	else:
		current_target.is_grabbed = true
	$AnimatedSprite2D.position = $AnimatedSprite2D.position.lerp(Vector2(0.0, -10.0), delta * 0.1)
	current_target.global_position = $AnimatedSprite2D/HoldPoint.global_position


func move_hand_towards_target(delta):
	position = position.lerp(current_target.global_position, delta * 2.5)
	if position.distance_to(current_target.global_position) <= 4.0:
		$AnimatedSprite2D.play("grabbing")
		state = states.IDLE
		$HoldWait.start()
		await $HoldWait.timeout
		$Grab.play()
		state = states.GRABBING


func go_home(delta):
	position = lerp(position, home_position, delta * 4.0)
	if position.distance_to(home_position) <= 1.0:
		$AnimationPlayer.play("throw")


func throw_target():
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.position.y = -60.0
	current_target.angular_velocity = randf_range(-5, 5)
	current_target.linear_velocity = Vector2(-500, -100)
	if current_target.is_in_group("player"):
		current_target.set_collision_layer_value(1, true)
	else:
		current_target.is_grabbed = false
	state = states.IDLE
	$Throw.play()
	$Refactory.start()
	await $Refactory.timeout
	finished_throwing.emit()
	state = states.RETREAT
	$TillDeath.start()
	await $TillDeath.timeout
	queue_free()


func retreat(delta):
	$AnimatedSprite2D.rotation = lerp($AnimatedSprite2D.rotation, 0.0, delta)
	position.y -= 1.0

