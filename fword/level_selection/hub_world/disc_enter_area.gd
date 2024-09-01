extends Area2D

@export var disc_number: int
@export var animated_image: SpriteFrames
@export var gradient: GradientTexture2D

var player_inside: bool = false


func _process(delta):
	if Input.is_action_just_pressed("jump") and player_inside:
		$SceneChangeNode.go_next_scene()
		AllDiscs.current_disc = disc_number


func _on_body_entered(body):
	if body.is_in_group("player"):
		ShaderEffects.get_node("GradientMapShaderCanvas").get_node("GradientMapShader").set_gradient_with_file(gradient)
		player_inside = true
		$AnimatedSprite2D.play("open")

func _on_body_exited(body):
	if body.is_in_group("player"):
		$AnimatedSprite2D.play_backwards("open")
		player_inside = false
