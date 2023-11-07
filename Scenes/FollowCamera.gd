extends Camera2D

@export var TARGET: Node2D

func _physics_process(delta):
	if TARGET:
		position = TARGET.position
