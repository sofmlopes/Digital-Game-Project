extends Node2D


func _on_level_complete() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/Ending.tscn")
