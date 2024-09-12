extends CanvasLayer

signal total_eclipse
@export var play_speed = 1.2


func _ready():
	$AnimationPlayer.speed_scale = play_speed
	print("my speed is: ", $AnimationPlayer.speed_scale)


func _on_animation_player_animation_finished(_anim_name):
	queue_free()


func total_eclipse_occured():
	total_eclipse.emit()
