extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const ARM_MAX_DISTANCE = 50.0

const LEFT_ARM_OFFSET = Vector2(-32, 0)
const RIGHT_ARM_OFFSET = Vector2(32, 0)

@onready var left_hand = $LeftHand
@onready var right_hand = $RightHand

var left_arm_axis = Vector2.ZERO
var right_arm_axis = Vector2.ZERO

func _process(delta: float) -> void:
	# Get joystick input
	var left_x = Input.get_axis("left_left", "left_right")
	var left_y = Input.get_axis("left_up", "left_down")
	
	var right_x = Input.get_axis("right_left", "right_right")
	var right_y = Input.get_axis("right_up", "right_down")
	
	left_arm_axis = Vector2(left_x, left_y) * ARM_MAX_DISTANCE
	
	right_arm_axis = Vector2(right_x, right_y) * ARM_MAX_DISTANCE

	# Print the result for debugging
	print("Left Arm Axis:", left_arm_axis)
	print("Right Arm Axis:", right_arm_axis)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Left Hand
	var left_hand_offset = left_arm_axis
	left_hand.global_position = self.global_position + left_hand_offset + LEFT_ARM_OFFSET

	# Right Hand
	var right_hand_offset = right_arm_axis
	right_hand.global_position = self.global_position + right_hand_offset + RIGHT_ARM_OFFSET

	# Character movement
	move_and_slide()
