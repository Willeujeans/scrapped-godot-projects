extends Node2D

func _on_button_pressed():
	print("I WAS PRESSED")
	print(get_parent().get_class())
	get_parent().enter_game()
