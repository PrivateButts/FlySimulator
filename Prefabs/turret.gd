extends Node2D

func _physics_process(_delta):
	# Get position of the player and rotate to face it
	var player = (get_node("../Player") as Node2D)
	if player:
		look_at(player.position)
