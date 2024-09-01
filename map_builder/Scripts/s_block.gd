extends Node3D
var mapLocation = Vector3(0,0,0)
var terrainType = "b"
@onready var door = load("res://models/door.obj")
var change = 0.05
var rng = RandomNumberGenerator.new()
func _ready():
	var randomNumber = rng.randf_range(0.0, 0.02)
	var colorBasedOnHeight = Color(randomNumber+0.75-(mapLocation.y*change-0.1),randomNumber+0.75-mapLocation.y*change,0.65-mapLocation.y*change,1)
	set_Color(colorBasedOnHeight)

func set_TerrainType(in_terrain):
	terrainType = in_terrain

func set_MapLocation(in_vector):
	mapLocation = in_vector

func set_Mesh(in_meshObject):
	if $MeshInstance3D != null:
		$MeshInstance3D.set_mesh(in_meshObject)
		$MeshInstance3DMove.set_mesh(in_meshObject)
		#$MeshInstance3DStatic.set_mesh(in_meshObject)
		$terrainLayer.set_mesh(in_meshObject)
		getVerticies($MeshInstance3D)

func set_outlineVisibility(in_bool):
	$MeshInstance3D2.visible = in_bool


func set_Color(colorInput):
	var myMaterial = StandardMaterial3D.new()
	#var outLine = load("res://materials/outLineMaterial.tres")
	#myMaterial.next_pass = outLine
	myMaterial.albedo_color = colorInput
	$MeshInstance3D.set_surface_override_material(0, myMaterial)

func _on_area_3d_mouse_entered():
	var shell = get_tree().get_root().get_node("shell")
	var playerController = shell.get_node("container").get_node("mapWorld").get_node("player")
	playerController.set_HoveredBlock(self)
	playerController.set_Height()
	
	
func getVerticies(in_meshInstance):
	var mdt = MeshDataTool.new() 
	var grabbedMesh = in_meshInstance.get_mesh()
	#get surface 0 into mesh data tool
	mdt.create_from_surface(grabbedMesh, 0)
	for vtx in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(vtx)
		print("Local Vertex: " , vert)
