extends MovementState


class_name IdleState


func enter(previous_state):
	if animation_player.is_playing() and animation_player.current_animation == "land":
		await animation_player.animation_finished
		animation_player.pause()
	else:
		animation_player.pause()
		


func exit():
	animation_player.speed_scale = 1.0


func physics_update(delta):
	character.low = false
	character.update_gravity(delta)
	character.update_input()
	character.update_velocity(max_speed, acceleration, deceleration, delta)
	
	if Input.is_action_just_pressed("shift"):
		transition.emit("CrouchState")
	
	if character.direction:
		if character.direction.length() > 0 and character.is_on_floor():
			transition.emit("RunState")
	
	if Input.is_action_just_pressed("space_bar"):
		if character.jump_available:
			transition.emit("JumpState")
	
	pass
