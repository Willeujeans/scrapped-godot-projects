extends Node2D
@onready var line: Line2D = Line2D.new()
@export var curve: Resource
@export var gradient: Resource

func _ready():
	call_deferred("add_child", line)
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	line.width = 1
	line.set_end_cap_mode(2)
	line.gradient = gradient


func _process(delta):
	if $RayCast2D.is_colliding():
		line.set_point_position(1, to_local($RayCast2D.get_collision_point()))
	else:
		line.set_point_position(1, $RayCast2D.target_position)
