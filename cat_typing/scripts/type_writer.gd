extends Node
var words = ["beautiful","cute","nice","perfect","cool","sweet","flowers","leaves","trees","amazing"]
var phrase = ""
var letterVisuals = []
var count = 0;
signal step(count)
var rng = RandomNumberGenerator.new()
var scene = load("res://Scenes/fallingLetter.tscn")
var difficultyLifeSpan = 20

func _ready():
	createNewNote()
	print(phrase)
	var guide = ""
	for n in phrase.length():
		if n == 0:
			guide += "^"
		else:
			guide += "-"
	print(guide)

func setDifficulty():
	difficultyLifeSpan -= 2

func createNewNote():
	setDifficulty()
	constructPhrase()
	createVisual()
	rotatePaper()

func constructPhrase():
	phrase = ""
	for n in 5:
		var myRand = rng.randi_range(0,words.size()-1)
		phrase += words[myRand]
		phrase += " "

func createVisual():
	letterVisuals = []
	var letterSpread = 400
	var spaceSize = -20
	var letterSize = 0
	for n in phrase:
		var instance = scene.instantiate()
		instance.get_node("Control").setLifeSpan(difficultyLifeSpan)
		letterVisuals.push_back(instance)
		letterSize = instance.get_node("Control").get_node("RichTextLabel").get_size().x
		instance.position.y = 400
		instance.position += (instance.get_position() + Vector2(letterSpread,0))
		var textChild = instance.get_node("Control").get_node("RichTextLabel")
		if n == " ":
			textChild.set_text("[center]"+"_"+"[/center]")
		else:
			textChild.set_text("[center]"+n+"[/center]")
		add_child(instance)
		letterSpread += (spaceSize + letterSize)
		await get_tree().create_timer(0.05).timeout

func rotatePaper():
	get_node("Paper").rotation = Vector3(42,0,0)


func printGuide():
	print(phrase)
	var guide = ""
	for n in phrase.length():
		if n == count:
			guide += "^"
		else:
			guide += "-"
	print(guide)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_handler_typed(letter):
	if(count < letterVisuals.size()):
		if letter == phrase[count].to_lower():
			letterVisuals[count].get_node("Control").killRight()
			count += 1
		else:
			letterVisuals[count].get_node("Control").killWrong()
			count += 1
	if(count >= phrase.length()):
		count = 0
		createNewNote()
	printGuide()


