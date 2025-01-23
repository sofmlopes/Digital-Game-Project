extends RigidBody2D  # Ensure your node is RigidBody2D

@export var fall_delay: float = 2.5  # Time delay before the platform starts falling
@export var affected_group: String = "monkey"  # Group to detect (e.g., the player)

func _ready() -> void:
	# Set RigidBody2D to "Static" mode initially
	sleeping = true
	gravity_scale = 0
	physics_material_override = PhysicsMaterial.new()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(affected_group):
		print("Triggered: Starting fall delay")
		# Wait for the delay and then make the platform fall
		await get_tree().create_timer(fall_delay).timeout
		start_falling()

func start_falling() -> void:
	sleeping = false  # Wake up the rigid body
	gravity_scale = 1  # Enable gravity to make the platform fall
