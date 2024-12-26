extends Node2D

@onready var skeleton = $skeleton

# Called every frame
func _process(delta: float) -> void:
	# Get joystick input for x and y axes
	var move_x = Input.get_axis("move_left", "move_right")
	var move_y = Input.get_axis("move_up", "move_down")
	
	var left_hand = skeleton.get_bone(4)
	
	if move_x == 1:
		print(skeleton.get_bone(4))
		print(skeleton.get_bone(4).get_length())
		
