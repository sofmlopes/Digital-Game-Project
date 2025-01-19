extends RigidBody2D

const JUMP_VELOCITY = -400.0
const ARM_MAX_DISTANCE = 50.0

const LEFT_ARM_OFFSET = Vector2(-32, 0)
const RIGHT_ARM_OFFSET = Vector2(32, 0)

@onready var left_hand = get_node("../LeftHand")
@onready var right_hand = get_node("../RightHand")

var left_arm_axis = Vector2.ZERO
var right_arm_axis = Vector2.ZERO

var left_hand_can_grab = null
var right_hand_can_grab = null

var is_left_grabbing = false

func _process(delta: float) -> void:
	# Get joystick input
	var left_x = Input.get_axis("move_leftarm_left", "move_leftarm_right")
	var left_y = Input.get_axis("move_leftarm_up", "move_leftarm_down")
	
	var right_x = Input.get_axis("move_rightarm_left", "move_rightarm_right")
	var right_y = Input.get_axis("move_rightarm_up", "move_rightarm_down")
	
	left_arm_axis = Vector2(left_x, left_y) * ARM_MAX_DISTANCE
	
	right_arm_axis = Vector2(right_x, right_y) * ARM_MAX_DISTANCE
	
	if Input.is_action_pressed("grab_left") and left_hand_can_grab != null and is_left_grabbing == false: #need to save which object it was
		print("idk")
		is_left_grabbing = true
	elif Input.is_action_just_released("grab_left"):
		is_left_grabbing = false

func _physics_process(delta: float) -> void:
	# Gravity
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Left Hand
	if !is_left_grabbing:
		var left_hand_offset = left_arm_axis
		left_hand.global_position = self.global_position + left_hand_offset + LEFT_ARM_OFFSET
	else:
		var left_hand_offset = left_arm_axis
		#self.global_position = left_hand.global_position - left_hand_offset - LEFT_ARM_OFFSET
		# Apply force to move the player toward the left hand
		var target_position = left_hand.global_position - left_hand_offset - LEFT_ARM_OFFSET
		var current_position = self.global_position
		var direction: Vector2 = (target_position - current_position)
		var distance = (target_position - current_position).length()

		# Apply a force proportional to the distance
		var force = direction * min(distance * 0.05, 1)  # Adjust values for speed and max force
		self.apply_impulse(force, Vector2(0, 0))

	# Right Hand
	var right_hand_offset = right_arm_axis
	right_hand.global_position = self.global_position + right_hand_offset + RIGHT_ARM_OFFSET


func _on_lefthand_body_entered(body: Node2D) -> void:
	left_hand_can_grab = body
	print("LeftHand can grab")

func _on_lefthand_body_exited(body: Node2D) -> void:
	left_hand_can_grab = false
	print("LeftHand cant grab")
