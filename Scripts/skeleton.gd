extends Skeleton2D

# Define bone names
var left_arm_index = 3
var right_arm_index = 6
var hand_locked = false
@onready var character_body = self.get_parent().get_parent() # Replace this with the path to your physics node
@export var max_offset = 300.0
@export var max_stretch = 200.0  # Maximum arm stretch length

# Movement boundaries for bones (in degrees for rotation)
@export var arm_rotation_bounds = {
	"min_angle": -20,  # Minimum rotation in degrees
	"max_angle": 20    # Maximum rotation in degrees
}

# Joystick sensitivity
var joystick_sensitivity = 100.0

# Arm offsets
var left_arm_offset = Vector2.ZERO
var right_arm_offset = Vector2.ZERO

# Spring joints
var spring_joint_left = null
var spring_joint_right = null

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

	# Update offsets
	left_arm_offset = Vector2(
		0,
		clamp(left_y * max_offset, -max_offset, 0)
	)

	right_arm_offset = Vector2(
		0,
		clamp(right_y * max_offset, -max_offset, 0)
	)
	
	# Apply offsets to arm positions
	apply_arm_offset(left_arm_index, left_arm_offset)
	apply_arm_offset(right_arm_index, right_arm_offset)
	
	apply_arm_rotation(left_arm_index, left_x)
	apply_arm_rotation(right_arm_index, right_x)

	# Update spring joint rest length based on joystick input (for stretching)
	if spring_joint_left:
		var stretch_factor_left = clamp(left_y, -1.0, 1.0)
		spring_joint_left.rest_length = max_stretch + (stretch_factor_left * max_stretch * 0.5)
		
	if spring_joint_right:
		var stretch_factor_right = clamp(right_y, -1.0, 1.0)
		spring_joint_right.rest_length = max_stretch + (stretch_factor_right * max_stretch * 0.5)

func apply_arm_rotation(bone_index, x_input):
	if bone_index == -1:
		return

	# Get the bone by index
	var bone = get_bone(bone_index)

	# Get the current rotation
	var current_rotation = bone.rotation_degrees

	# Calculate new rotation based on X-axis input
	var new_rotation = current_rotation + x_input * joystick_sensitivity * get_process_delta_time()

	# Clamp the rotation
	new_rotation = clamp(new_rotation, arm_rotation_bounds["min_angle"], arm_rotation_bounds["max_angle"])

	# Apply the rotation
	bone.rotation_degrees = new_rotation

func apply_arm_offset(bone_index, offset):
	if bone_index == -1:
		return

	# Get the bone's current transform
	var bone = get_bone(bone_index)

	# Set the new position within limits
	var original_position = bone.rest.origin
	var new_position = original_position + offset

	# Ensure the bone doesn't move below the original Y position
	if new_position.y > original_position.y:
		new_position.y = original_position.y

	# Apply the new transform to the bone
	bone.position = new_position


# Grab event handler: Handle spring joint creation/removal
#func _on_grab_event(hand_id: Variant, grabbing: Variant, grabbed_platform: Node2D) -> void:
	#if grabbing:
		#print(hand_id, "hand is grabbing!")
		#lock_hand(hand_id)
		##_create_spring_joint(hand_id, grabbed_platform)
	#else:
		#print(hand_id, "hand released!")
		##_remove_spring_joint(hand_id)
#
#func lock_hand(hand_name: String):
	#var hand_index = -1
	#if hand_name == "left":
		#hand_index = 4  # Replace with the actual bone index for the left hand
	#elif hand_name == "right":
		#hand_index = 7  # Replace with the actual bone index for the right hand
	#
	#if hand_index != -1:
		#var current_pose = get_bone_local_pose_override(hand_index)
		#if current_pose == null:
			#current_pose = Transform2D()  # Default pose if not overridden
		## Lock the hand by setting a persistent local pose override
		#set_bone_local_pose_override(hand_index, current_pose, 1.0, true)
#
#func disable_gravity():
	#character_body.velocity = Vector2.ZERO  # Stops any movement from velocity
	#character_body.move_and_slide()
