extends Area2D
class_name HurtBoxComponent

@export var damage = 1


func _on_body_entered(body: Node):
	print(body.name)
	if body is PlayerCharacter:
		body.damage.emit(damage, self)
