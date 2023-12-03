extends Node2D


func _on_tracking_targets(bodies):
	look_at(bodies[0].position)
