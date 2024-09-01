extends  GrooveJoint2D

@export var max_height = 200.0
@export var speed = 10.0
var current_added = 0.0
var starting_x = 0.0
var is_active = false
var is_extending = true

func _ready():
	set_node_a("../")

func activate():
	if !is_active:
		is_active = true

func _process(delta):
	if is_active:
		extend()

func extend():
	$AnimatedSprite2D.play("open")
	self.length += 1.0
	$RigidBody2D.position.y += 1.0
