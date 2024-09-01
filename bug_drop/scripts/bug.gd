extends RigidBody2D
var jumped = false
var spawned = false
@onready var nextBug = load(get_meta("nextBugPath"))
@onready var debugMarker = load("res://scenes/pointBugTester.tscn")
#Collision issue, when a larger body is created it will sometimes shove a smaller one outside the box bounds

func _ready():
	pass
	
func _process(_delta):
	pass

func spawnBug(midPoint):
	var newNextBug = nextBug.instantiate()
	get_parent().add_child(newNextBug)
	newNextBug.global_position = midPoint

func _on_area_2d_area_entered(area:Area2D):
	print(area)
	if area.get_parent().get_meta("myName") == get_meta("myName"):
		#Possible bug, midpoint being calculated outside of the BOX bounds
		var xMid = (area.get_parent().global_position.x + global_position.x)/2
		var yMid = (area.get_parent().global_position.y + global_position.y)/2
		var midPoint = Vector2(xMid,yMid)
		var debugMarkernew = debugMarker.instantiate()
		debugMarkernew.position = midPoint
		get_parent().add_child(debugMarkernew)
		#Issue where sometimes will spawn two bugs, if collision is slow enough
		if area.get_parent().spawned == false:
			get_parent().increase_points(get_meta("pointCount"))
			spawned = true
			call_deferred("spawnBug", midPoint)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
