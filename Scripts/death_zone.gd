extends Node


#Entered the colision area so we should kill the player
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("monkey"):
		body.die()
