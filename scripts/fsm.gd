extends Node

var debug = false
var STATES = {}
var state_current = null
var state_next = null
var obj = null

func _init(obj, states_parent_node, initial_state, debug = false):
	self.obj = obj
	self.debug = debug
	_set_states_parent_node(states_parent_node)
	state_next = initial_state
	pass

func _set_states_parent_node(pnode):
	if debug: 
		print("Found ", pnode.get_child_count(), " states")
	if pnode.get_child_count() == 0:
		return
	var state_nodes = pnode.get_children()
	for state_node in state_nodes:
		if debug: 
			print("adding state: ", state_node.name)
		STATES[state_node.name] = state_node

func run_machine(delta):
	if state_next != state_current:
		if state_current != null:
			if debug:
				print(obj.name, ": changing from state ", state_current.name, " to ", state_next.name)
			state_current.terminate(obj)
		elif debug:
			print(obj.name, ": starting with state ", state_next.name)
		state_current = state_next
		state_current.initialize(obj)
	# run state
	state_current.run(obj, delta)

