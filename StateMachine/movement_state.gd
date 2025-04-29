extends State


class_name MovementState


# Movement speed caps and values
@export_range(5, 20) var max_speed = 14.0 ## Maximum speed the player can get to
@export_range(5, 20) var acceleration = 10 ## How fast the player accelerates in desired direction
@export_range(5, 20) var deceleration = 14 ## How fast the player decelerates


var character: Character
var animation_player : AnimationPlayer


func _ready() -> void:
	await owner.ready
	character = owner as Character
	animation_player = character.animation_player
	pass
