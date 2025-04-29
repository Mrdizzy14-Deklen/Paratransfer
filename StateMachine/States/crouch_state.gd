extends MovementState


class_name CrouchState


# Movement speed caps and values
@export_range(5, 20) var max_crouch_speed = 5.0 ## Maximum speed the player can get to


var crouch_speed = 7.0 ## The speed the player crouches and uncrouches


var crouch_check ## The shapecast detecting the ceiling




func enter(previous_state):
	crouch_check = character.crouch_check
	animation_player.speed_scale = 1.0
	if previous_state.name == "SlideState":
		animation_player.current_animation = "crouch"
		animation_player.seek(1.0, true)
	elif !character.low:
		animation_player.play("crouch", -1, crouch_speed)


func exit():
	animation_player.speed_scale = 1.0


func physics_update(delta):
	character.low = true
	character.update_gravity(delta)
	character.update_input()
	if character.is_on_floor():
		character.update_velocity(max_crouch_speed, acceleration, deceleration, delta)
	else:
		character.update_velocity(max_speed, acceleration, deceleration, delta)
	
	if !Input.is_action_pressed("shift"):
		uncrouch()
	
	if Input.is_action_just_pressed("space_bar"):
		if character.jump_available:
			transition.emit("JumpState")
	
	pass


func uncrouch():
	if !crouch_check.is_colliding() and !Input.is_action_pressed("shift"):
		animation_player.speed_scale = 1.0
		animation_player.play("crouch", -1, -crouch_speed, true)
		if animation_player.is_playing():
			await animation_player.animation_finished
			transition.emit("IdleState")
			return
	pass
