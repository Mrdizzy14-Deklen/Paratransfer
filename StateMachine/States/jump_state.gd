extends MovementState


class_name JumpState


var start_state
var jump_buffer = false


func enter(previous_state):
	character.velocity.y = character.jump_velocity
	if character.dash_jump:
		character.velocity += character.direction * character.velocity.length() * character.dash_jump
		character.dash_jump = 0
	character.jump_available = false
	if previous_state.name != "JumpState" and previous_state.name != "WallrunState":
		start_state = previous_state
	


func physics_update(delta):
	character.update_input()
	character.update_velocity(max_speed, acceleration, deceleration, delta)
	
	# Add gravity.
	if !character.is_on_floor():
		
		# Apply less gravity on ascent
		if Input.is_action_pressed("space_bar"):
			character.velocity.y += jump_stage() * delta
		else:
			character.velocity.y += character.fall_gravity * delta
		
		if Input.is_action_just_pressed("space_bar"):
			jump_buffer = true
	
	if character.is_on_floor():
		if !character.low:
			animation_player.play("land")
			
		if jump_buffer:
			jump_buffer = false
			transition.emit("IdleState")
			transition.emit("JumpState")
		else:
			transition.emit(start_state.name)
	if Input.is_action_pressed("shift"):
			if Global.check_wall_run(character):
				transition.emit("WallrunState")
	
	#await get_tree().create_timer(3).timeout
	#jump_buffer = false


## Determine which part of a jump the player is in
func jump_stage():
	if character.velocity.y > 0:
		if start_state.name == "CrouchState":
			return character.jump_gravity * 2
		else:
			return character.jump_gravity
	
	if start_state.name == "CrouchState":
		return character.fall_gravity * 2
	else:
		return character.jump_gravity
	pass
