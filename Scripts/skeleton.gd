extends Skeleton2D

const JUMP_VELOCITY = -400.0
const ARM_MAX_DISTANCE = 300.0

const LEFT_ARM_OFFSET = Vector2(-200, -400)
const RIGHT_ARM_OFFSET = Vector2(200, -400)

var left_arm_axis = Vector2.ZERO
var right_arm_axis = Vector2.ZERO

# Define bone names
var left_arm_index = 3
var right_arm_index = 6
var hand_locked = false
@onready var character_body = self.get_parent().get_parent() # Replace this with the path to your physics node

# Arm offsets
var left_arm_offset = Vector2.ZERO
var right_arm_offset = Vector2.ZERO

func _ready():
	# Find bone indices
	if get_bone(left_arm_index) == null or get_bone(right_arm_index) == null:
		print("Error: Bone(s) not found!")
	
	if left_arm_index == -1 or right_arm_index == -1:
		print("Error: Bone(s) not found!")

func _process(_delta):
	if left_arm_index == -1 or right_arm_index == -1:
		return

	# Joystick input (controller 0)
	var left_x = Input.get_axis("move_leftarm_left", "move_leftarm_right")
	var left_y = Input.get_axis("move_leftarm_up", "move_leftarm_down")

	var right_x = Input.get_axis("move_rightarm_left", "move_rightarm_right")
	var right_y = Input.get_axis("move_rightarm_up", "move_rightarm_down")
	
	
