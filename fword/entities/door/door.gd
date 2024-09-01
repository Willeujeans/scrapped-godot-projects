extends Node2D

@export var signalLayer = 0
var can_activate = true

func activate():
	if can_activate:
		can_activate = false
		$AnimationPlayer.play("doorOpen")
		$AudioStreamPlayer.play()
