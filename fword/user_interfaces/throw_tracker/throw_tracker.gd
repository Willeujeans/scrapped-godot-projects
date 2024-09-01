extends Control

@export var ui_scene: PackedScene
@onready var thrown_count: int = 0
var ui_element_array: Array = []
var three_star
var two_star
var one_star


func set_star_numbers(in_three_star, in_two_star, in_one_star):
	three_star = in_three_star
	two_star = in_two_star
	one_star = in_one_star
	populate_throw_tracker()


func populate_throw_tracker():
	for each in one_star + 1:
		var throw_tracker_element = ui_scene.instantiate()
		if each == three_star or each == two_star or each == one_star:
			throw_tracker_element.set_star(true)
		ui_element_array.append(throw_tracker_element)
	ui_element_array.reverse()
	for elem in ui_element_array:
		$HBoxContainer.add_child(elem)
	ui_element_array.reverse()


func drop_element():
	if thrown_count > ui_element_array.size()-1:
		return
	ui_element_array[thrown_count].drop_element()
	thrown_count += 1
