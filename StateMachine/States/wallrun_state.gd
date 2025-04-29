extends MovementState


class_name WallrunState


func enter(previous_state):
	animation_player.pause()
	pass


func exit():
	animation_player.speed_scale = 1.0
	pass


func physics_update(delta):
	character.update_input()
	
	var wall_collision = character.get_slide_collision(0)
	if wall_collision:
		character.last_wall = wall_collision.get_collider()
		
	# Check for inputs
	if Input.is_action_pressed("shift"):
		
		## Jump off wall if too slow
		if character.velocity.length() <= 6:
			leave()
			character.last_wall = wall_collision.get_collider()
		else:
			# Lock y pos and cling to wall
			if character.is_on_wall():
				character.velocity.y = 0
				character.direction += -wall_collision.get_normal() * 8
			else:
				leave()
			
	else:
		
		# Jump off wall if release the wall run
		leave()
	
	character.update_velocity(max_speed, acceleration, deceleration, delta)
	pass


func leave():
	if Input.is_action_pressed("space_bar"):
		character.dash_jump = 1
		transition.emit("JumpState")
	else:
		transition.emit("IdleState")
