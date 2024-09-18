extends CPUParticles2D

@export var amplitude = 1.0
@export var frequency = 1.0
var step = 0


func _process(delta):
	position.x = amplitude * cos(step * frequency)
	step += delta * 1.0
