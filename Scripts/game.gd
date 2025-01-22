extends Node2D

var levels = [$Level1, $Level2]
var current_lvl_idx = 0

func load_next_level():
	current_lvl_idx += 1
	if current_lvl_idx < levels.size():
		get_tree().change_scene(levels[current_lvl_idx])
	else:
		print("No more levels!")
