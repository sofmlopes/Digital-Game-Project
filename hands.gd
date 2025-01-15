extends Area2D

var is_grabbing = false
var grabbed_object = null
var grab_button_pressed = false

func _ready():
	
	# Determine if this is the left or right hand based on position
	if position.x < get_parent().position.x:
		# Left hand
		grab_button_pressed = Input.is_action_pressed("grab_left")
	else:
		# Right hand
		grab_button_pressed = Input.is_action_pressed("grab_right")

func _on_body_entered(body):
	if body.is_in_group("grabbable"):
		if grab_button_pressed:
			grabbed_object = body
			is_grabbing = true
			print("Grabbing platform")

func _on_body_exited(body):
	if grabbed_object == body:
		grabbed_object = null
		is_grabbing = false
		print("Released platform")

func _process(_delta):
	if grab_button_pressed:
		print("pressing")
	if is_grabbing:
		# Make the hand follow the grabbed object
		position = grabbed_object.position
