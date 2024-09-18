extends Control
@export var levels: Array[PackedScene]
@export var level_container_scene: PackedScene
var level_elements = []
var elements_random_rotations = []
var elements_random_position = []
var total_stars = 0
var speed = 10.0
var center_index = 0


func format_time(milliseconds: int) -> String:
	var total_seconds = milliseconds / 1000
	#var minutes = total_seconds / 60
	var seconds = total_seconds
	var ms = milliseconds % 1000
	return str(seconds) + "." + str(ms)[0] + " s"


func _ready():
	var set_focus = false
	var current_x = 0
	var last_button = null
	var level_index = 0
	for each in levels:
		var color_in_node_name = each.get_state().get_node_name(1)
		var stars_in_node_name = each.get_state().get_node_name(2)
		var colors_list = color_in_node_name.split("_")
		var stars_list = stars_in_node_name.split("*")
		var level_container = level_container_scene.instantiate()
		level_container.list_of_colors = colors_list
		level_container.set_level(each)
		level_container.get_node("SceneChangeNode").current_parent_scene = self.get_path()
		level_container.get_node("Control").get_node("Name").set_text("[center]" + str(each.get_state().get_node_name(0)) + "[/center]")
		if get_tree().get_first_node_in_group("level_progress").level_times.has(str(each.get_state().get_node_name(0))):
			var saved_time = get_tree().get_first_node_in_group("level_progress").level_times[str(each.get_state().get_node_name(0))]
			var saved_time_in_seconds = saved_time / 1000
			var formatted_time = format_time(saved_time)
			level_container.get_node("Control").get_node("Time").set_text("[center]" + formatted_time + "[/center]")
			var stars_from_level = 0
			if saved_time_in_seconds <= int(stars_list[0]):
				stars_from_level += 1
				level_container.get_node("Control").get_node("StarCount").set_text("[center]" + "+" + "[/center]")
			if saved_time_in_seconds <= int(stars_list[1]):
				stars_from_level += 1
				level_container.get_node("Control").get_node("StarCount").set_text("[center]" + "++" + "[/center]")
			if saved_time_in_seconds <= int(stars_list[2]):
				stars_from_level += 1
				level_container.get_node("Control").get_node("StarCount").set_text("[center]" + "+++" + "[/center]")
			if saved_time_in_seconds <= int(stars_list[3]):
				stars_from_level += 1
				level_container.get_node("Control").get_node("Button").set("theme_override_styles/normal", load("res://menus/level_select/level_container_button_4Star.tres"))
				level_container.get_node("Control").get_node("Button").set("theme_override_styles/focus", load("res://menus/level_select/level_container_button_4Star.tres"))
				level_container.get_node("Control").get_node("Button").set_material(load("res://2D_shine_canvas.tres"))
			total_stars += stars_from_level
		else:
			level_container.get_node("Control").get_node("Time").set_text("[center]" + "x" + "[/center]")
		$Carousell.add_child(level_container)
		level_container.position.x = current_x
		current_x += 460
		if not set_focus:
			level_container.get_node("Control").get_node("Button").grab_focus()
			set_focus = true
		level_elements.append(level_container)
		var rando_rotation = deg_to_rad(randf_range(-10.0, 10.0))
		var rando_position = Vector2(current_x + randf_range(-15.0, 15.0), randf_range(-100.0, 20.0))
		level_container.rotation = rando_rotation
		level_container.position = rando_position
		elements_random_rotations.append(rando_rotation)
		elements_random_position.append(rando_position)
		level_index += 1
		
	level_elements[0].get_node("Control").get_node("Button").focus_neighbor_left = level_elements[-1].get_node("Control").get_node("Button").get_path()
	level_elements[-1].get_node("Control").get_node("Button").focus_neighbor_right = level_elements[0].get_node("Control").get_node("Button").get_path()
	for i in range(len(level_elements)):
		if i - 1 >= 0:
			level_elements[i].get_node("Control").get_node("Button").focus_neighbor_left = level_elements[i - 1].get_node("Control").get_node("Button").get_path()
		if i + 1 < len(level_elements):
			level_elements[i].get_node("Control").get_node("Button").focus_neighbor_right = level_elements[i + 1].get_node("Control").get_node("Button").get_path()


func _process(delta):
	if Input.is_action_just_pressed("reset"):
		for i in range(len(level_elements)):
			if level_elements[i].get_node("Control").get_node("Button").has_focus():
				level_elements[i].flip()
	var center_of_screen = get_viewport().get_visible_rect().size / 2
	var current_center = null
	for i in range(len(level_elements)):
		if level_elements[i].get_node("Control").get_node("Button").has_focus():
			current_center = level_elements[i]
			center_index = i
			level_elements[i].z_index = 5
			level_elements[i].modulate = lerp(level_elements[i].modulate, Color(1.0,1.0,1.0,1.0), delta * speed)
			level_elements[i].rotation = lerp(level_elements[i].rotation, 0.0, delta * speed)
			level_elements[i].position.y = lerp(level_elements[i].position.y, -100.0, delta * speed)
			level_elements[i].scale = lerp(level_elements[i].scale, Vector2(1.2, 1.2), delta * speed)
		else:
			level_elements[i].modulate = lerp(level_elements[i].modulate, Color(0.6,0.6,0.6,1.0), delta * speed)
			level_elements[i].position = lerp(level_elements[i].position, elements_random_position[i], delta * speed)
			level_elements[i].rotation = lerp(level_elements[i].rotation, elements_random_rotations[i], delta * speed)
			level_elements[i].z_index = 0
			level_elements[i].position.y = lerp(level_elements[i].position.y, 0.0, delta * speed)
			level_elements[i].scale = lerp(level_elements[i].scale, Vector2(1.0, 1.0), delta * speed)
	if $Carousell:
		$Carousell.position.x = lerp($Carousell.position.x, center_of_screen.x - (current_center.position.x + 200), delta * speed)
