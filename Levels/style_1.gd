extends Node3D


@onready var parkour_timer: RichTextLabel = $CanvasLayer/ParkourTimer
@onready var finish_label: Label3D = $Labels/FinishLabel
@onready var timer_timer: Timer = $TimerTimer


var time_elapsed = 0.0
var running = false
var completed = false

func _process(delta: float) -> void:
	if running:
		finish_label.visible = false
		time_elapsed += delta
		parkour_timer.text = str(Global.round_place(time_elapsed, 2))
		parkour_timer.visible = true
	pass


func _on_timer_start_body_entered(body: Node3D) -> void:
	running = true
	time_elapsed = 0
	completed = false
	pass


func _on_fail_box_body_entered(body: Node3D) -> void:
	running = false
	finish_label.visible = false
	timer_timer.start()
	pass


func _on_timer_end_body_entered(body: Node3D) -> void:
	if running:
		running = false
		completed = true
		finish_label.visible = true
		if time_elapsed < 34.73:
			finish_label.text = str("Good work getting all the \nway up here! And congrats on beating my time! \nYour time was: ", Global.round_place(time_elapsed, 2), " and my time was: 34.73!")
		else:
			finish_label.text = "Good work getting all the \nway up here! Now that you've done it, \ntry and beat my time of 34.73!"
	timer_timer.start()
	pass


func _on_timer_timer_timeout() -> void:
	parkour_timer.visible = false
	pass
