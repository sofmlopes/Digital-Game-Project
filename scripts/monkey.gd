extends Node2D

@onready var skeleton = $skeleton
@onready var left_hand = skeleton.get_bone(4)
@onready var initial_left_hand_positon = left_hand.rest

func _process(delta: float) -> void:
	var move_x = Input.get_axis("move_left", "move_right")
	var move_y = Input.get_axis("move_up", "move_down")
	
	var new_position = initial_left_hand_positon.origin + Vector2(move_x * -200, move_y * -200)
	
	# Create a new Transform2D with the updated origin
	var new_transform = Transform2D(initial_left_hand_positon.x, initial_left_hand_positon.y, new_position)
	print(new_transform)
	
	# Apply the new rest transform
	left_hand.rest = new_transform
