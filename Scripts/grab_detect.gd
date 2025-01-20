extends RigidBody2D

var grabbing = false
var grabbed_platform: Node2D = null

signal grab_event(hand_id, grabbing)
@export var hand_id = "left"

@onready var skeleton = $"../../../skeleton"  # Adjust the path to your Skeleton2D
@export var bone_idx = "4"  # Set the bone name corresponding to this hand

func _ready():
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC  # Default to static (not affected by forces)

func _process(delta):
	# Synchronize the RigidBody2D's position with the bone
	if skeleton and skeleton.get_bone(bone_idx) != -1:
		global_position = skeleton.get_bone_local_pose_override(skeleton.get_bone(bone_idx)).origin
		

	# Handle grabbing state
	if Input.is_action_pressed("grab_left"):  # Adjust for the correct hand
		if grabbed_platform and not grabbing:
			grabbing = true
			freeze_mode = RigidBody2D.FREEZE_MODE_STATIC  # Lock the hand in place
			print(hand_id + " Grabbing started")
			emit_signal("grab_event", hand_id, grabbing, grabbed_platform)

	elif Input.is_action_just_released("grab_left") and grabbing:
		grabbing = false
		freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC  # Release the hand but keep collision checks
		print(hand_id + " Grabbing ended")
		emit_signal("grab_event", hand_id, grabbing, grabbed_platform)

func _on_body_entered(body):
	if body.is_in_group("grabbable") and not grabbing:
		grabbed_platform = body
		print(hand_id + " platform detected:", grabbed_platform)

func _on_body_exited(body):
	if body == grabbed_platform:
		grabbed_platform = null
		print(hand_id + " platform released")
