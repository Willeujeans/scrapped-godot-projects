extends Node

@onready var menuScene = load("res://scenes/Menu_container.tscn")
var menuContainer

@onready var gameScene = load("res://scenes/Game_container.tscn")
var gameContainer
@onready var myRect = $ColorRect
@onready var anim_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.

func _ready():
	print("Container active")
	createMenu()

func createMenu():
	menuContainer = menuScene.instantiate()
	add_child(menuContainer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func enter_game():
	anim_player.play("fade_out")
	menuContainer.z_index = -1

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade_out":
			gameContainer = gameScene.instantiate()
			add_child(gameContainer)
			menuContainer.queue_free()
			anim_player.play("fade_in")
		"fade_in":
			myRect.visible = false
