extends Node
var alphabet = "abcdefghijklmnopqrstuvwxyz "

signal typed(letter)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;

func _input(event):
	for i in alphabet:
		if event.is_action_pressed(i):
			typed.emit(i)

