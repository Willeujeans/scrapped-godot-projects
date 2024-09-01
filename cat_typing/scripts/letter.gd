extends Control
var flip = false
var target = get_position()
var t = 0
var is_bouncing = true
var is_shaking = false
var originalPos = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var count = 0
var lifeSpan = 0

func setLifeSpan(in_life):
	lifeSpan = in_life

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("RichTextLabel").modulate.a -= 0.5
	originalPos = position
	target = get_position()
	t = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_bouncing:
		bouncing(delta)
	if is_shaking:
		shaking(delta)

var is_right = true
var intensity = 1


func increaseIntensity():
	intensity += 1.3

func shaking(delta):
	if(is_right):
		rotation += sin(delta*intensity)
	else:
		rotation -= sin(delta*intensity)
	if rotation < -0.2:
		is_right = true
		print("move left")
	if rotation > 0.2:
		is_right = false
		print("move right")

func bouncing(delta):
	t += delta * 1
	position = position.lerp(target, t)
	if position == target:
		count += 1
		t=0
		if count > 2:
			is_bouncing=false
				
		if flip == true:
			flip=false
			target.y += 20
		else:
			flip=true
			target.y -= 40

func killRight():
	is_bouncing = false
	is_shaking = false
	get_node("RichTextLabel").modulate.a += 0.5
	get_owner().gravity_scale = 1
	get_owner().set_linear_velocity(Vector2(-100,-400))
	get_owner().angular_velocity = rng.randi_range(-15,15)
	await get_tree().create_timer(3).timeout
	queue_free()
	
func killWrong():
	is_bouncing = false
	is_shaking = false
	var textLabel = get_node("RichTextLabel")
	textLabel.modulate.a += 0.5
	textLabel["theme_override_colors/default_color"] = Color8(255, 0, 0)  
	get_owner().gravity_scale = 0.5
	get_owner().set_linear_velocity(Vector2(0,-100))
	get_owner().angular_velocity = rng.randi_range(-1,1)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_timer_timeout():
	lifeSpan -= 1
	if lifeSpan <= 5:
		is_shaking = true
		increaseIntensity()
	if lifeSpan <= 0 && is_shaking == true:
		killWrong()
