@tool
extends SubViewport


# enable in editor
func _enter_tree():
	print("called")
	call_deferred("fix_world")

func fix_world():
	print("answered")
	world_2d = get_parent().get_viewport().world_2d
