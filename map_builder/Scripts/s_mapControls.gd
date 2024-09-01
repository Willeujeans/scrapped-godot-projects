extends Control
@onready var shell = get_tree().get_root().get_node("shell")
var UIlock = false
# Called when the node enters the scene tree for the first time.
func _ready():
	print("map controls loaded")


func _on_door_button_pressed():
	var map = shell.get_node("container").get_node("mapWorld").get_node("mapManager")
	map.currentTerrain = "e"

func _on_mouse_entered():
	shell.get_node("tmp").UIlock = true
	print(shell.get_node("tmp").UIlock)


func _on_mouse_exited():
	shell.get_node("tmp").UIlock = false
	print(shell.get_node("tmp").UIlock)


func _on_save_button_pressed():
	shell.get_node("container").get_node("mapWorld").get_node("mapManager").saveCurrentMap()


func _on_door_button_mouse_entered():
	shell.get_node("tmp").UIlock = true
	print(shell.get_node("tmp").UIlock)


func _on_door_button_mouse_exited():
	shell.get_node("tmp").UIlock = false
	print(shell.get_node("tmp").UIlock)


func _on_save_button_mouse_entered():
	shell.get_node("tmp").UIlock = true
	print(shell.get_node("tmp").UIlock)


func _on_save_button_mouse_exited():
	shell.get_node("tmp").UIlock = false
	print(shell.get_node("tmp").UIlock)
