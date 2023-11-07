extends CharacterBody2D


@export var GRAVITY: float = 200
@export var ACCELERATION: float = 1000
@export var MAX_SPEED: float = 100
@export var TURN_RATE: float = 200
@export var DRAG: float = .99
@export var BOUNCE_DRAG: float = .1


func _physics_process(delta):
	var input = get_movement_vector()
	
	# Apply movement
	var local_velocity = Vector2.UP * input.y * ACCELERATION * delta
	
	# Rotate
	rotation_degrees += input.x * TURN_RATE * delta
	velocity -= local_velocity.rotated(rotation-1.5708)
	
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	# Apply drag
	velocity *= DRAG

	# Limit speed
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

	var collision = move_and_collide(velocity * delta)

	if collision:
		velocity = velocity.bounce(collision.get_normal())
		velocity *= BOUNCE_DRAG
		# move_and_collide(velocity * delta)


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	var y_movement = Input.get_action_strength("reverse") - Input.get_action_strength("thrust")
	return Vector2(x_movement, y_movement)
