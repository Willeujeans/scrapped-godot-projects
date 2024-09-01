extends Node
signal state_changed(current_state)
@export var START_STATE: String = "state"
var states_map = {}
var states_stack = []
var current_state = null
var _active = false :
	set(value):
		set_active(value)

func _ready():
	for child in get_children():
		child.finished.connect(_change_state)
	initialize(START_STATE)

func _process(delta):
	check_for_state()

func check_for_state():
	return
	
func initialize(start_state):
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()


func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null


func _input(event):
	current_state.handle_input(event)


func _physics_process(delta):
	current_state.update(delta)


func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)


func _change_state(state_name):
	if not _active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	emit_signal("state_changed", current_state)
	
	if state_name != "previous":
		current_state.enter()


# player:
# func _process(delta):
# state_machine()

# STATE MACHINE
# It should know the current state
# It should run through all states to see which one should be active
# If a different state than current should be active, it changes state
