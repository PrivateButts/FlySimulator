extends Area2D

class_name DetectionZoneComponent

signal TargetAcquired(body: Node2D)
signal TargetLost(body: Node2D)
signal TrackingTargets(bodies: Array[Node2D])

@export var GROUP_FILTER: String = "players"
var targets: Array[Node2D] = []


func _on_body_entered(body: Node2D):
	if body not in targets and body.is_in_group(GROUP_FILTER):
		targets.append(body)
		TargetAcquired.emit(body)
		print("Tracking "+body.name)


func _on_body_exited(body: Node2D):
	if body in targets:
		targets.erase(body)
		TargetLost.emit(body)
		print("Stopped tracking "+body.name)


func _physics_process(delta):
	if len(targets)>0:
		TrackingTargets.emit(targets)
