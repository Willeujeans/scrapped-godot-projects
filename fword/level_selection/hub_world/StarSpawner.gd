extends Node2D

@export var star: PackedScene

func _ready():
	var total_stars = SaveManager.get_data("total_stars")
	for each in total_stars:
		var flower = star.instantiate()
		flower.position = self.global_position
		flower.position.x += randf_range(-10, 10)
		# this continues even after it shouldn't
		$"../..".call_deferred("add_child", flower)
		$Timer.start()
		await $Timer.timeout
