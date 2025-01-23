extends Area2D


#this will be controlled by the monkey's main script
var grabbing = false
var current_body = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grabbing == true and current_body != null and current_body.is_in_group("falling_objects"):
		current_body.start_timer()
		print("timer started")

func _on_body_entered(body: Node2D) -> void:
	current_body = body
