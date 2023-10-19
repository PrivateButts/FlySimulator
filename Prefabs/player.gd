extends CharacterBody2D


@export var GRAVITY: float = 200
@export var ACCELERATION: float = 1000
@export var MAX_SPEED: float = 100
@export var TURN_RATE: float = 200


func _physics_process(delta):
	var input = get_movement_vector()
	
	rotation_degrees += input.x * TURN_RATE * delta
	var local_velocity = Vector2.UP * input.y * ACCELERATION * delta
	velocity -= local_velocity.rotated(rotation-1.5708)
	velocity.y += GRAVITY * delta
	move_and_slide()


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	var y_movement = Input.get_action_strength("reverse") - Input.get_action_strength("thrust")
	return Vector2(x_movement, y_movement)
