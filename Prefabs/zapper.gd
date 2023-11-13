extends Area2D

const damage = 10


func _on_body_entered(body: Node):
	print(body.name)
