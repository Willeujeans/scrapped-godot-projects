extends Node2D

@export var signalLayer: int = 0
@export var button_pressed_image: Texture
@export var button_unpressed_image: Texture
var is_pressed: bool = false
var itemsInsideButton = []

func _process(_delta):
	if $buttonBody/RayCast2D.is_colliding():
		if !is_pressed:
			pressed()
		is_pressed = true
	else:
		if is_pressed:
			unpressed()
		is_pressed = false


func pressed():
	var all_activatables = get_tree().get_nodes_in_group("activatables")
	$ClickAudio.play()
	$BloopAudio.play()
	for each in all_activatables:
		if each.signalLayer == signalLayer:
			each.activate()
	is_pressed = true
	$Sprite2D.set_texture(button_pressed_image)


func unpressed():
	$Sprite2D.set_texture(button_unpressed_image)
	is_pressed = false
