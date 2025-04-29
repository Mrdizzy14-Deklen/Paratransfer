extends MovementState


class_name RunState


@export var top_anim_speed : float = 1


func enter(previous_state):
	if animation_player.is_playing() and animation_player.current_animation == "land":
		await animation_player.animation_finished
		animation_player.play("running", -1, 2)
	else:
		animation_player.play("running", -1, 2)


func exit():
	animation_player.speed_scale = 1.0


func physics_update(delta):
	character.low = false
	character.update_gravity(delta)
	character.update_input()
	character.update_velocity(max_speed, acceleration, deceleration, delta)
	
	if Input.is_action_pressed("shift"):
		if character.velocity.length() <= 6:
			transition.emit("CrouchState")
		else:
			if character.is_on_wall() and !character.is_on_floor():
				transition.emit("WallrunState")
			else:
				transition.emit("SlideState")
		
	
	if character.direction.length() <= 0:
		transition.emit("IdleState")
	
	
	if Input.is_action_just_pressed("space_bar"):
		if character.jump_available:
			character.dash_jump = 1
			transition.emit("JumpState")
	
	pass


func update(delta):
	set_anim_speed(character.velocity.length())
	pass


func set_anim_speed(speed):
	var alpha = remap(speed, 0.0, max_speed, 0.0, 1.0)
	animation_player.speed_scale = lerp(0.0, top_anim_speed, alpha)
