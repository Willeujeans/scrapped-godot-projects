extends Area2D

@export var display: PackedScene
var game_over = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.can_act = false
		game_over = true
		get_parent().call_deferred("add_child",display.instantiate())


func _process(delta):
	if game_over:
		var number = AudioServer.get_bus_volume_db(0)
		number -= 0.1
		if number >= -100.0:
			AudioServer.set_bus_volume_db(0, number)
