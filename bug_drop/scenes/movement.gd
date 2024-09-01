extends Node

var checkForAnts = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if checkForAnts:
		findAllAnts()

func findAllAnts():
	var antList = []
	for _i in get_parent().get_parent().get_children():
		if _i.has_meta("myName"):
			if _i.get_meta("myName") == "ant":
				if _i.get_node("movement").checkForAnts:
					antList.append(_i)
	if antList.size() > 1:
		var antToGoTo = findClosestAnt(antList)
		#print(antToGoTo.get_meta("myName"))
		#moveToAnt(antToGoTo)

func findClosestAnt(antList):
	var closestAnt
	var closestDistance = 1000
	for ant in antList:
		var xDiff = ant.global_position.x-get_parent().global_position.x
		var yDiff = ant.global_position.y-get_parent().global_position.y
		var distance = sqrt(pow(xDiff,2)+pow(yDiff,2))
		if distance < closestDistance && distance != 0:
			closestDistance = distance
			closestAnt = ant
	print(closestAnt)
	return closestAnt

func moveToAnt(antToGoTo):
	if get_parent().global_position.x < antToGoTo.global_position.x:
		get_parent().add_constant_force(Vector2(1,0))
	else:
		get_parent().add_constant_force(Vector2(-1,0))

func _on_rigid_body_2d_body_entered(body):
	checkForAnts = true
