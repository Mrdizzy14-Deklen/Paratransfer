extends Control


@onready var sens_slider: HSlider = $"Sens Slider"
@onready var fov_slider: HSlider = $"FOV Slider"
@onready var fov_display: Label = $"FOV Display"
@onready var sens_display: Label = $"Sens Display"


func style_1() -> void:
	set_params()
	LoadManager.changeSceneTo("res://Levels/style_1.tscn")
	pass


func style_2() -> void:
	set_params()
	LoadManager.changeSceneTo("res://Levels/style_2.tscn")
	pass


func style_3() -> void:
	set_params()
	pass


func style_4() -> void:
	set_params()
	pass


func set_params():
	Global.sens = sens_slider.value
	Global.fov = fov_slider.value
	pass


func _on_sens_slider_changed(val) -> void:
	sens_display.text = str(val)


func _on_fov_slider_changed(val) -> void:
	fov_display.text = str(val)
