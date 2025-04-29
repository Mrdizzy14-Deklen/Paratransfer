extends CharacterBody3D


class_name Character


@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var camera_mount: Node3D = $Camera3D

@onready var crouch_check: ShapeCast3D = $CrouchCheck


@export var camera_sens = Vector2(2, 2) ## Sensitivity of the player camera


var direction ## The intended direction the player is moving
var jump_available = false ## If the player can jump
var crouching = false ## If the player is crouching
var just_landed = false ## Queues triggers on land

# Used to determine jump height and velocity
@export_range(1, 5) var jump_height : float = 2 ## The max height a jump can get
@export var jump_time_up : float = 0.5 ## The target time for ascent to apex
@export var jump_time_down : float = 0.3 ## The target time for descent to ground

# Used to determine gravity
@onready var jump_gravity : float = (-2 * jump_height) / pow(jump_time_up, 2) ## Gravity when the player is ascending
@onready var fall_gravity : float = (-2 * jump_height) / pow(jump_time_down, 2) ## Gravity when the player is descending
@onready var jump_velocity : float = (2 * jump_height) / jump_time_up ## The power the player jumps with

# Misc
var last_wall = null ## Used to keep player from climbing using wallrun
var dash_jump = 0 ## Used to trigger a dash jump
var low = false ## If the character is crouching/sliding


func _ready() -> void:
	
	Global.player = self
	
	# Lock mouse to screen
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	camera_mount.fov = Global.fov
	camera_sens = Vector2(Global.sens, Global.sens)


func _input(event: InputEvent) -> void:
	
	# Look with mouse
	if event is InputEventMouseMotion:
		camera_mount.rotation.y -= event.relative.x * (camera_sens.x / 1000)
		camera_mount.rotation.y = wrapf(camera_mount.rotation.y, 0.0, TAU)
		#visuals.rotate_y(deg_to_rad(event.relative.x*camera_sens.x))
		camera_mount.rotation.x -= event.relative.y * (camera_sens.y / 1000)
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, -PI/2, PI/3)
	


func _process(delta: float) -> void:
	if velocity.length() > 6:
		camera_mount.fov = lerp(camera_mount.fov, (clamp(velocity.length() * 10, Global.fov, Global.fov * 1.25)), delta * velocity.length()/2)
	else:
		camera_mount.fov = lerp(camera_mount.fov, Global.fov, delta * 6)
	pass


func update_input():
	var input_dir := Input.get_vector("a", "d", "w", "s")
	
	# Normalize and rotate to fit camera
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, camera_mount.global_rotation.y)
	pass


func update_gravity(delta):
	
	if is_on_floor():
		last_wall = null
		if just_landed and !low:
			animation_player.play("land")
		
		#Make jump available if on ground
		jump_available = true
		
		just_landed = false
	else:
		velocity.y += fall_gravity * delta
		just_landed = true
		jump_available = false
	
	pass


func update_velocity(max_speed, acceleration, deceleration, delta):
	move(max_speed, acceleration, deceleration, delta)
	move_and_slide()


func move(max_speed, acceleration, deceleration, delta):
	if direction:
		velocity.x = lerp(velocity.x, direction.x * max_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * max_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, direction.x * max_speed, deceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * max_speed, deceleration * delta)
