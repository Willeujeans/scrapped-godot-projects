extends Node

@onready var scoreVisual = $Score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var points = 0
func increase_points(amount):
	points += amount
	scoreVisual.text = ("[center]" + str(points) + "[/center]")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
