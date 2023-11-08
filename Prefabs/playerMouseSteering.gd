extends CharacterBody2D


@export var ACCELERATION: float = 1000
@export var MAX_SPEED: float = 100
@export var MIN_SPEED: float = 10
@export var DRAG: float = .99
@export var DRIFT_DRAG: float = .5
@export var BOUNCE_DRAG: float = .1
@export var LAND_MARGIN: float = 1.1

var LANDED: bool = false


func _physics_process(delta):
	var input = get_movement_vector()
	
	# Apply movement
	var input_velocity = (Vector2.UP * input.y + Vector2.LEFT * input.x) * ACCELERATION * delta

	if LANDED and input_velocity.length() > 0:
		print("take off")
		LANDED = false
	
	# Rotate to face mouse
	if not LANDED:
		var mouse_position = get_global_mouse_position()
		look_at(mouse_position)
		# var direction = mouse_position - global_position
		# velocity = direction.normalized() * velocity.length()
		# velocity += input_velocity.rotated(rotation-1.5708)

		var local_velocity = velocity.rotated(-rotation)
		if local_velocity.length() > MIN_SPEED or local_velocity.y < 0:
			local_velocity.y *= DRIFT_DRAG
		local_velocity += input_velocity.rotated(-1.5708)
		velocity = local_velocity.rotated(rotation)
		
	# Apply drag
	if velocity.length() > MIN_SPEED:
		velocity *= DRAG

	# Limit speed
	if velocity.length() > MAX_SPEED:
		print("max speed")
		velocity = velocity.normalized() * MAX_SPEED

	var collision = move_and_collide(velocity * delta)

	if collision:
		var normal = collision.get_normal()
		if velocity.length() > MIN_SPEED * LAND_MARGIN:
			velocity = velocity.bounce(normal)
			velocity *= BOUNCE_DRAG
		else:
			velocity = Vector2.ZERO
			# Align to surface
			rotation = normal.angle() + 1.5708
			
			LANDED = true
			print("landed")


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	var y_movement = Input.get_action_strength("reverse") - Input.get_action_strength("thrust")
	return Vector2(x_movement, y_movement)
