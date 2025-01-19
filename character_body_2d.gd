extends RigidBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var spring_joint_left = null
@onready var spring_joint_right = null
@export var max_stretch = 1
@export var spring_stiffness = 1000
@export var spring_damping = 1

#func _physics_process(delta: float) -> void:
	## Use gravity only if no hands are grabbing
	#velocity += Vector2(1,1) * delta  # Apply gravity to the whole velocity vector
	#move_and_slide()



# Called when grabbing starts or stops (from hand script)
func handle_grab_event(hand_id, grabbing, grabbed_platform):
	if grabbing:
		create_spring_joint(hand_id, grabbed_platform)
	else:
		remove_spring_joint(hand_id)

func create_spring_joint(hand_id, grabbed_platform):
	if hand_id == "left" and !spring_joint_left:
		spring_joint_left = DampedSpringJoint2D.new()
		#spring_joint_left.set_rest_length(0)
		#spring_joint_left.set_stiffness(10000)
		#spring_joint_left.set_damping(500)
		spring_joint_left.set_node_a($"Node2D (Monkey)/skeleton/chest/shoulders/upperarm_left/forearm_left/hand_left/HandBody".get_path())   # Path to hand body
		spring_joint_left.set_node_b(grabbed_platform.get_path())  # The grabbed platform
		$"Node2D (Monkey)/skeleton/chest/shoulders/upperarm_left/forearm_left/hand_left/HandBody".add_child(spring_joint_left)  # Add the spring joint to the character body
		print("devia funcionar")

	#elif hand_id == "right" and !spring_joint_right:
		#spring_joint_right = DampedSpringJoint2D.new()
		#spring_joint_right.node_a = $Skeleton2D/hand_right  # The hand bone
		#spring_joint_right.node_b = grabbed_platform  # The grabbed platform
		#spring_joint_right.rest_length = max_stretch
		#spring_joint_right.stiffness = spring_stiffness
		#spring_joint_right.damping = spring_damping
		#add_child(spring_joint_right)  # Add the spring joint to the character body

func remove_spring_joint(hand_id):
	pass
	#if hand_id == "left" and spring_joint_left:
		#spring_joint_left.queue_free()  # Remove the spring joint
		#spring_joint_left = null
	#elif hand_id == "right" and spring_joint_right:
		#spring_joint_right.queue_free()  # Remove the spring joint
		#spring_joint_right = null
