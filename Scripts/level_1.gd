extends Node2D


func _on_level_complete() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level2.tscn")
