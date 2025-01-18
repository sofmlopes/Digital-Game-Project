extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var grabbing_hand_count = 0  # Count of hands grabbing a surface

func _physics_process(delta: float) -> void:
	# Use gravity only if no hands are grabbing
	if grabbing_hand_count == 0:
		velocity += get_gravity() * delta  # Apply gravity to the whole velocity vector

	# Ensure proper movement handling
	move_and_slide()
