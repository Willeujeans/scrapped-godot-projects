extends Control


func _ready():
	$VBoxContainer/HBoxContainer/Control5/TimeText.text = "[center]" + ("%.1f" % ((get_tree().get_first_node_in_group("level_progress").level_times[0]* 0.001)/1.0)).replace(".", ":") + "s" + "[/center]"
	$VBoxContainer/HBoxContainer/Control2/TimeText.text = "[center]" + ("%.1f" % ((get_tree().get_first_node_in_group("level_progress").level_times[1]* 0.001)/1.0)).replace(".", ":") + "s" + "[/center]"
	$VBoxContainer/HBoxContainer/Control3/TimeText.text = "[center]" + ("%.1f" % ((get_tree().get_first_node_in_group("level_progress").level_times[2]* 0.001)/1.0)).replace(".", ":") + "s" + "[/center]"
	$VBoxContainer/HBoxContainer/Control4/TimeText.text = "[center]" + ("%.1f" % ((get_tree().get_first_node_in_group("level_progress").level_times[3]* 0.001)/1.0)).replace(".", ":") + "s" + "[/center]"
