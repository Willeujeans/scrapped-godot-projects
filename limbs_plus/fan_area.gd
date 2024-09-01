extends Area2D
@export var power = 700.0
@onready var direction = (to_global($RayCast2D.target_position) - $RayCast2D.global_position).normalized()

func _ready():
	gravity_direction = direction
	gravity = power
	$CPUParticles2D.gravity = direction * max(100, (power/2))
	$CPUParticles2D.amount = max(3, power/100)
