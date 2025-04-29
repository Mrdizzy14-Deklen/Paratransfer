extends MovementState


class_name SlideState


@export_range(0, 0.1) var tilt_amount: float = 0.09 ## The distance the player tilts when sliding

var slide_speed = 4.0

var crouch_check ## The shapecast detecting the ceiling

var velocity_lerp_t = 0

func enter(previous_state):
	animation_player.get_animation("sliding").track_set_key_value(4, 0, character.velocity.length())
	animation_player.speed_scale = 1.0
	if !character.low:
		animation_player.play("sliding", -1.0, slide_speed)
	crouch_check = character.crouch_check
	velocity_lerp_t = 0


func exit():
	animation_player.speed_scale = 1.0


func physics_update(delta):
	character.low = true
	if character.is_on_floor():
		var floor_normal = character.get_floor_normal()
		var downhill_speed = character.velocity.dot(Vector3.DOWN.slide(floor_normal.normalized()))
		if downhill_speed > 1:
			character.velocity += Vector3.DOWN.slide(floor_normal.normalized()) * delta * 1000
			character.velocity += -floor_normal * 500 * delta
			
		else:
			velocity_lerp_t += delta * 0.4
			var t = clamp(velocity_lerp_t, 0.0, 1.0)
			var eased_t = t * t * t
			
			character.velocity = character.velocity.cubic_interpolate(Vector3.ZERO, character.velocity.normalized() * 10, character.velocity.normalized() * 4, eased_t)
			
	if !Input.is_action_pressed("shift"):
		finish()
	character.update_gravity(delta)
	character.update_velocity(max_speed, acceleration, deceleration, delta)
	
	if Input.is_action_just_pressed("space_bar"):
		if character.jump_available:
			character.dash_jump = 2
			transition.emit("JumpState")
	
	pass


func finish():
	transition.emit("CrouchState")
	pass
