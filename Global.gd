extends Node


var player

var fov = 90.0

var sens = 2.0

func check_wall_run(guy):
	if guy.is_on_wall() and !guy.is_on_floor():
		var wall_collision = guy.get_slide_collision(0)
		if wall_collision:
			var wall = wall_collision.get_collider()
			# Check if on a new wall
			if wall != guy.last_wall:
				return true
	return false


func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
