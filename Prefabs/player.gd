extends CharacterBody2D
class_name PlayerCharacter

signal damage(amount: float, source: Node)

@export var GAME_OVER_SCENE: PackedScene
var HEALTH: float = 1

func dead():
	print("dead")
	var game_over = GAME_OVER_SCENE.instantiate()
	get_tree().get_root().add_child(game_over)
	queue_free()


func _on_damage(amount: float, source: Node):
	print("Damaged by "+source.name)
	HEALTH -= amount
	
	if HEALTH <= 0:
		dead()
