extends Node

var timeCount = 0
var difficulty = 0
var difficultyTimers = [10,9,8,7,6,5,4]
# Called when the node enters the scene tree for the first time.
func _ready():
	timeCount
	difficulty = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal loss()
