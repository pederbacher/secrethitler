extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		var newPauseState = !get_tree().paused
		get_tree().paused = newPauseState
		visible = newPauseState