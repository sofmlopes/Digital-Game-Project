extends Node2D

var reset_hold_time: float = 0.0
const RESET_HOLD_DURATION = 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("play_again"):
		reset_hold_time += delta
		if reset_hold_time >= RESET_HOLD_DURATION:
			get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")
			reset_hold_time = 0.0  # Reset the hold time
	else:
		reset_hold_time = 0.0  # Reset the counter if not holding
