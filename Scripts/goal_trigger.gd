extends Area2D

signal level_complete


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monkey"):	
		emit_signal("level_complete")
