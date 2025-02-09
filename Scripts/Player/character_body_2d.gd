extends RigidBody2D

const JUMP_VELOCITY = -400.0
const ARM_MAX_DISTANCE = 40.0

const LEFT_ARM_OFFSET = Vector2(-32, -22)
const RIGHT_ARM_OFFSET = Vector2(32, -22)

const RESET_HOLD_DURATION: float = 2.0 

const DEFAULT_ZOOM = 2.5
const REDUCED_ZOOM = 1.5

var reset_hold_time: float = 0.0

@onready var left_hand = get_node("../LeftHand")
@onready var right_hand = get_node("../RightHand")

@onready var left_hand_sound: AudioStreamPlayer2D = get_node("../LeftHand/GrabSound")
@onready var right_hand_sound: AudioStreamPlayer2D = get_node("../RightHand/GrabSound")

@onready var left_grab_notifier = get_node("../LeftHand/left_collision")
@onready var right_grab_notifier = get_node("../RightHand/right_collision")

@onready var camera = $Camera2D
@onready var death_sound = $DeathSound


var left_arm_axis = Vector2.ZERO
var right_arm_axis = Vector2.ZERO

#these are numeric so it doesnt bug if the hand touches 2 different grabbale objects at the same time
var left_hand_can_grab = 0
var right_hand_can_grab = 0

var is_left_grabbing = false
var is_right_grabbing = false

@onready var skeleton = $"Node2D (Monkey)/skeleton"
@onready var left_hand_bone = 4
@onready var right_hand_bone = 7

@onready var text_red = preload("res://Assets/Red-Circle-Transparent.png")
@onready var text_green = preload("res://Assets/Green-Circle.png")

func _process(delta: float) -> void:
	
	var left_x = Input.get_axis("move_leftarm_left", "move_leftarm_right")
	var left_y = Input.get_axis("move_leftarm_up", "move_leftarm_down")
	
	var right_x = Input.get_axis("move_rightarm_left", "move_rightarm_right")
	var right_y = Input.get_axis("move_rightarm_up", "move_rightarm_down")
	
	left_arm_axis = Vector2(left_x, left_y) * ARM_MAX_DISTANCE
	
	right_arm_axis = Vector2(right_x, right_y) * ARM_MAX_DISTANCE
		
	if Input.is_action_pressed("zoom_out"):
		camera.zoom.x = REDUCED_ZOOM
		camera.zoom.y = REDUCED_ZOOM
	else:
		camera.zoom.x = DEFAULT_ZOOM
		camera.zoom.y = DEFAULT_ZOOM
	
	if Input.is_action_pressed("grab_left") and left_hand_can_grab > 0 and is_left_grabbing == false: #need to save which object it was
		is_left_grabbing = true
		left_grab_notifier.grabbing = true
		left_hand_sound.play()
	elif Input.is_action_just_released("grab_left"):
		is_left_grabbing = false
		left_grab_notifier.grabbing = false
		
	if Input.is_action_pressed("grab_right") and right_hand_can_grab > 0 and is_right_grabbing == false: #need to save which object it was
		is_right_grabbing = true
		right_grab_notifier.grabbing = true
		right_hand_sound.play()
	elif Input.is_action_just_released("grab_right"):
		is_right_grabbing = false
		right_grab_notifier.grabbing = false
		
	# Check reset action hold time
	if Input.is_action_pressed("reset_level"):
		reset_hold_time += delta
		if reset_hold_time >= RESET_HOLD_DURATION:
			die()  # Trigger the reset
			reset_hold_time = 0.0  # Reset the hold time
	else:
		reset_hold_time = 0.0  # Reset the counter if not holding

func _physics_process(delta: float) -> void:
	# Gravity
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Left Hand
	if !is_left_grabbing:
		left_hand.texture = text_red
		left_hand.modulate = Color(1,1,1,0.5)
		var left_hand_offset = left_arm_axis
		left_hand.global_position = self.global_position + left_hand_offset + LEFT_ARM_OFFSET

	else:
		left_hand.texture = text_green
		left_hand.modulate = Color(1,1,1,0.5)
		var left_hand_offset = left_arm_axis
		pull_player_to_hand(left_arm_axis, left_hand, LEFT_ARM_OFFSET)

	# Right Hand
	if !is_right_grabbing:
		right_hand.texture = text_red
		right_hand.modulate = Color(1,1,1,0.5)
		var right_hand_offset = right_arm_axis
		right_hand.global_position = self.global_position + right_hand_offset + RIGHT_ARM_OFFSET
	else:
		right_hand.texture = text_green
		right_hand.modulate = Color(1,1,1,0.5)
		var right_hand_offset = right_arm_axis
		pull_player_to_hand(right_arm_axis, right_hand, RIGHT_ARM_OFFSET)


func pull_player_to_hand(hand_axis, hand, arm_offset):
	var hand_offset = hand_axis
	var target_position = hand.global_position - hand_offset - arm_offset
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

func _on_lefthand_body_entered(body: Node2D) -> void:
	left_hand_can_grab += 1

func _on_lefthand_body_exited(body: Node2D) -> void:
	left_hand_can_grab -= 1
	is_left_grabbing = false

func _on_righthand_body_entered(body: Node2D) -> void:
	right_hand_can_grab += 1

func _on_righthand_body_exited(body: Node2D) -> void:
	right_hand_can_grab -= 1
	is_right_grabbing = false

func die() -> void:
	death_sound.play()
	await get_tree().create_timer(2.0).timeout  # Wait for 2 seconds
	get_tree().reload_current_scene()  # Reset the scene
