extends Node3D
@onready var menuScene = load("res://Scenes/mainMenu.tscn")
@onready var mapScene = load("res://Scenes/mapWorld.tscn")
@onready var shell = get_tree().get_root().get_node("shell")
# Called when the node enters the scene tree for the first time.
func _ready():
	$sceneChanger.changeSceneTo($container, menuScene)
