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
		var target_position = left_hand.global_position - left_hand_offset - LEFT_ARM_OFFSET
		var current_position = self.global_position
		var direction: Vector2 = (target_position - current_position)
		var distance = direction.length()

		# Velocity dampening
		var velocity_damping = 0.95  # Slowly reduce velocity to avoid overshooting
		linear_velocity *= velocity_damping

		if distance > 0.1:  # Only apply force if not close enough
			var target_velocity = direction * distance * 0.5  # Desired velocity toward the target
			var velocity_difference = target_velocity - linear_velocity  # Difference between current and target velocity

			# Apply force based on velocity difference
			var max_force = 10.0  # Limit the maximum force
			var force = velocity_difference
			self.apply_impulse(force, Vector2(0, 0))
		else:
			# Stop completely when close to the target
			linear_velocity = Vector2.ZERO

	# Right Hand
	var right_hand_offset = right_arm_axis
	right_hand.global_position = self.global_position + right_hand_offset + RIGHT_ARM_OFFSET


func _on_lefthand_body_entered(body: Node2D) -> void:
	left_hand_can_grab = body
	print("LeftHand can grab")

func _on_lefthand_body_exited(body: Node2D) -> void:
	left_hand_can_grab = false
	print("LeftHand cant grab")
