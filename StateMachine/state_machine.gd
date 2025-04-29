extends Node


class_name PlayerStateMachine


@export var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("Incorrect state")
	
	await owner.ready
	current_state.enter(current_state)
	pass


func _process(delta: float) -> void:
	current_state.update(delta)
	#print_debug(current_state)
	pass


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)
	pass


func on_child_transition(new_state_name: StringName):
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state:
			current_state.exit()
			new_state.enter(current_state)
			current_state = new_state
	else:
		push_warning("State nonexistent")
	pass
