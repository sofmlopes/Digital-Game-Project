extends Area2D

# Declare the hand's grabbing state
var grabbing = false
var grabbed_platform: Node2D = null  # The platform being grabbed

# Signal to notify when grabbing starts or stops
signal grab_event(hand_id, grabbing)  # hand_id will be "left" or "right"

@onready var hand_id = "left"  # Change to "right" for the other hand

# Called when the hand enters a grabbable platform
func _on_body_entered(body):
	if body.is_in_group("grabbable") and not grabbing:
		grabbed_platform = body
		print(hand_id + " platform detected:", grabbed_platform)

# Called when the hand exits the platform
func _on_body_exited(body):
	if body == grabbed_platform:
		grabbed_platform = null
		print(hand_id + " platform released")

# Called every frame
func _process(delta):
	# Check if the LT button (trigger) is being pressed
	if Input.is_action_pressed("grab_left"):  # Adjust "grab_left" to match your input mapping
		if grabbed_platform and not grabbing:
			grabbing = true  # Start grabbing
			print(hand_id + " Grabbing started")
			emit_signal("grab_event", hand_id, grabbing, grabbed_platform)

	if Input.is_action_just_released("grab_left") and grabbing:  # Trigger released
		grabbing = false  # End the grabbing state
		print(hand_id + " Grabbing ended")
		emit_signal("grab_event", hand_id, grabbing, grabbed_platform)
