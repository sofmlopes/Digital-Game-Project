extends Skeleton2D

# Define bone names
var left_arm_index = 3
var right_arm_index = 6

# Movement boundaries for bones (in degrees for rotation)
var arm_rotation_bounds = {
	"min_angle": -30,  # Minimum rotation in degrees
	"max_angle": 30    # Maximum rotation in degrees
}

# Joystick sensitivity
var joystick_sensitivity = 100.0  # Adjust for faster or slower movement

func _ready():
	# Find bone indices
	if get_bone(left_arm_index) == null or get_bone(right_arm_index) == null:
		print("Error: Bone(s) not found!")
	
	if left_arm_index == -1 or right_arm_index == -1:
		print("Error: Bone(s) not found!")

func _process(delta):
	if left_arm_index == -1 or right_arm_index == -1:
		return

	# Joystick input (controller 0)
	var left_joystick_y = Input.get_axis("move_leftarm_left", "move_leftarm_right") * joystick_sensitivity * delta
	var right_joystick_y = Input.get_axis("move_rightarm_left", "move_rightarm_right") * joystick_sensitivity * delta


	# Update bone rotations
	_move_bone(left_arm_index, left_joystick_y)
	_move_bone(right_arm_index, right_joystick_y)

func _move_bone(bone_index, y_input):
	# Get the bone by index
	var bone = get_bone(bone_index)
	if bone == null:
		return

	# Get the current bone rotation
	var current_rotation = bone.rotation_degrees

	# Calculate new rotation based on input
	var new_rotation = current_rotation + y_input

	# Clamp the new rotation to the defined boundaries
	new_rotation = clamp(new_rotation, arm_rotation_bounds["min_angle"], arm_rotation_bounds["max_angle"])

	# Apply the new rotation to the bone
	bone.rotation_degrees = new_rotation
