extends "state.gd"


func enter_condition()-> bool:
	if get_parent().velocity.x == 0:
		return true
	return false


# Initialize the state. E.g. change the animation
func enter():
	$"../../AnimatedSprite2D".play(self.state_name)
	return

# Clean up the state. Reinitialize values like a timer
func exit():
	return

func handle_input(event):
	return

func update(delta):
	return

func _on_animation_finished(anim_name):
	finished.emit()
	return
