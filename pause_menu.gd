extends Control


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	LoadManager.changeSceneTo("res://start_menu.tscn")
	pass


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	pass
