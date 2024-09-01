extends Node2D

var moving_left = false
var moving_right = false
@onready var ladyBugScene = load("res://scenes/ladyBug.tscn")
@onready var antScene = load("res://scenes/ant.tscn")
@onready var mothScene = load("res://scenes/moth.tscn")
var listOfBugs = []
var rng = RandomNumberGenerator.new()
var loadedBug
var canDrop = true
@onready var nextBugImage = $Sprite2D

func _ready():
	listOfBugs = [antScene,ladyBugScene,mothScene]
	loadUpBug()

func loadUpBug():
	var my_random_number = rng.randf_range(0, listOfBugs.size())
	loadedBug = listOfBugs[my_random_number].instantiate()
	nextBugImage.texture = loadedBug.get_node("Sprite2D").texture
	nextBugImage.scale = loadedBug.get_node("Sprite2D").scale
	nextBugImage.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if moving_right && position.x < 1920:
		position.x += 5
	if moving_left && position.x > 0:
		position.x -= 5

func _input(event):
	if event.is_action_pressed("move_left"):
		moving_left = true
		
	if event.is_action_released("move_left"):
		moving_left  = false
		
	if event.is_action_pressed("move_right"):
		moving_right = true
		
	if event.is_action_released("move_right"):
		moving_right = false
		
	if event.is_action_pressed("drop"):
		dropBug()

func dropBug():
	if nextBugImage.visible:
		nextBugImage.visible = false
		loadedBug.global_position = position
		get_parent().add_child(loadedBug)
		await get_tree().create_timer(.75 ).timeout
		loadUpBug()
