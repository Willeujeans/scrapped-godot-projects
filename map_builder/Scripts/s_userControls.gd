extends Node3D
@onready var shell = get_tree().get_root().get_node("shell")
var mapManager
var hoveredBlock
@onready var originalCameraRotation = $playerCamera.rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	mapManager = shell.get_node("container").get_node("mapWorld").get_node("mapManager")
	
func set_HoveredBlock(in_block):
	hoveredBlock = in_block

func set_Height():
	if !Input.is_action_pressed("clicked"):
		if !Input.is_action_pressed("otherClicked"):
			mapManager.currentHeight = hoveredBlock.mapLocation.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("save"):
		shell.get_node("container").get_node("mapWorld").get_node("mapManager").saveCurrentMap()
	if Input.is_action_just_pressed("rotateUp"):
		if $playerCamera.rotation == originalCameraRotation:
			$playerCamera.rotation = Vector3(-45,0,0)
			$playerCamera.position = $playerCamera.position + Vector3(0,0,10)
	if Input.is_action_just_pressed("rotateDown"):
		if $playerCamera.rotation == Vector3(-45,0,0):
			$playerCamera.rotation = originalCameraRotation
			$playerCamera.position = $playerCamera.position + Vector3(0,0,-10)
	if Input.is_action_pressed("up"):
		$playerCamera.position = $playerCamera.position + Vector3(0,0,-0.1)
	if Input.is_action_pressed("down"):
		$playerCamera.position = $playerCamera.position + Vector3(0,0,0.1)
	if Input.is_action_pressed("left"):
		$playerCamera.position = $playerCamera.position + Vector3(-0.1,0,0)
	if Input.is_action_pressed("right"):
		$playerCamera.position = $playerCamera.position + Vector3(0.1,0,0)
	
	if hoveredBlock != null:
		if Input.is_action_pressed("clicked"):
			if !shell.get_node("tmp").UIlock:
				if mapManager.currentHeight == hoveredBlock.mapLocation.y:
					var currentTerrain = get_parent().get_node("mapManager").currentTerrain
					mapManager.createSquare(Vector3(hoveredBlock.position.x,hoveredBlock.position.y+0.5,hoveredBlock.position.z), Vector3(hoveredBlock.mapLocation.x,hoveredBlock.mapLocation.y+1,hoveredBlock.mapLocation.z),currentTerrain)
				
		if Input.is_action_just_released("clicked"):
			mapManager.currentHeight = hoveredBlock.mapLocation.y
			
		if Input.is_action_just_released("otherClicked"):
			mapManager.currentHeight = hoveredBlock.mapLocation.y
			
		if Input.is_action_pressed("otherClicked"):
			if !shell.get_node("tmp").UIlock:
				if mapManager.currentHeight == hoveredBlock.mapLocation.y:
					mapManager.destroySquare(hoveredBlock)
