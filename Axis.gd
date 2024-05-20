
extends Node2D


class_name Axis
# export(int, 1, 20) var width = 10 setget set_width

#func set_width(v : int):
	#width = v
	#update()
	
var width = 10

func _draw() -> void:
	# if not Engine.editor_hint: return
	if not Engine.is_editor_hint():
		return
	draw_line(Vector2(-100000, 0), Vector2(100000, 0), Color.RED, width)
	draw_line(Vector2(0, -100000), Vector2(0, 100000), Color.GREEN, width)

