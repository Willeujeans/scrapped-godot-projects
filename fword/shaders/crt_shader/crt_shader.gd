extends ColorRect

var start_aberration: float = 0.003
var end_aberration: float = 0.04
var current_aberration: float = 0.003
var speed: float = 0.01
var start_warp: float = 0.1
var end_warp: float = 0.2
var current_warp: float = 0.1
var warp_speed: float = 0.01
var aberration_active: bool = false
var warp_active: bool = false

func _process(delta):
	if aberration_active:
		if current_aberration <= end_aberration and start_aberration != end_aberration:
			current_aberration += speed
			get_material().set_shader_parameter("aberration", current_aberration)
		if current_aberration >= end_aberration and start_aberration == end_aberration:
			if current_aberration <= end_aberration:
				current_aberration = end_aberration
				aberration_active = false
			current_aberration -= speed
			get_material().set_shader_parameter("aberration", current_aberration)
	if warp_active:
		if current_warp <= end_warp and start_warp != end_warp:
			current_warp += warp_speed
			get_material().set_shader_parameter("warp_amount", current_warp)
	
		if current_warp >= end_warp and start_warp == end_warp:
			if current_warp <= end_warp:
				current_warp = end_warp
				warp_active = false
			current_warp -= warp_speed
			get_material().set_shader_parameter("warp_amount", current_warp)


func shake_aberration():
	aberration_active = true
	warp_active = true
	end_aberration = 0.04
	end_warp = 0.2
	await get_tree().create_timer(0.5).timeout
	end_aberration = start_aberration
	end_warp = start_warp

