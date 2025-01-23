extends Sprite2D

var duration: float = 10.0
var start_pos: Vector2 = Vector2(960, 130)
var end_pos: Vector2 = Vector2(960, 940)
var elapsed_time: float = 0.0

func _ready() -> void:
	position = start_pos

func _process(delta: float) -> void:
	if elapsed_time < duration:
		elapsed_time += delta
		var t: float = elapsed_time / duration
		position = start_pos.lerp(end_pos, t)
