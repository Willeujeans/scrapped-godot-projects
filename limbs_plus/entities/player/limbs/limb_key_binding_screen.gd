extends CanvasLayer

@onready var limbs_key = ""
@onready var inactive = false
signal key_was_set

func _ready():
	print("we are inside the binding screen")

func _process(delta):
	if Input.is_action_just_pressed("h"):
		limbs_key = "h"
		key_was_set.emit("h")
		queue_free()
	elif Input.is_action_just_pressed("j"):
		limbs_key = "j"
		key_was_set.emit("j")
		queue_free()
	elif Input.is_action_just_pressed("k"):
		limbs_key = "k"
		key_was_set.emit("k")
		queue_free()
	elif Input.is_action_just_pressed("l"):
		limbs_key = "l"
		key_was_set.emit("l")
		queue_free()
