extends Node

var cb: CharacterBody2D

@export var ACCELERATION: float = 1000
@export var MAX_SPEED: float = 100
@export var MIN_SPEED: float = 10
@export var DRAG: float = .99
@export var DRIFT_DRAG: float = .5
@export var BOUNCE_DRAG: float = .1
@export var LAND_MARGIN: float = 1.1

var LANDED: bool = false


func _ready():
	var parent: Node2D = get_parent()
	if parent is CharacterBody2D:
		cb = parent as CharacterBody2D
	else:
		print("Mouse Steering Component must be a child of CharacterBody2D")
		print(self.get_path())
		queue_free()


func _physics_process(delta):
	var input = get_movement_vector()
	
	# Apply movement
	var input_velocity = (Vector2.UP * input.y + Vector2.LEFT * input.x) * ACCELERATION * delta

	if LANDED and input_velocity.length() > 0:
		LANDED = false
	
	# Rotate to face mouse
	if not LANDED:
		var mouse_position = cb.get_global_mouse_position()
		cb.look_at(mouse_position)
		# var direction = mouse_position - global_position
		# velocity = direction.normalized() * velocity.length()
		# velocity += input_velocity.rotated(rotation-1.5708)

		var local_velocity = cb.velocity.rotated(-cb.rotation)
		local_velocity += input_velocity.rotated(-1.5708)
		if local_velocity.length() > MIN_SPEED:
			local_velocity.y *= DRIFT_DRAG
		else:
			local_velocity = (Vector2.DOWN * MIN_SPEED).rotated(-1.5708)
		cb.velocity = local_velocity.rotated(cb.rotation)
		
	# Apply drag
	if cb.velocity.length() > MIN_SPEED:
		cb.velocity *= DRAG

	# Limit speed
	if cb.velocity.length() > MAX_SPEED:
		cb.velocity = cb.velocity.normalized() * MAX_SPEED

	var collision = cb.move_and_collide(cb.velocity * delta)

	if collision:
		var normal = collision.get_normal()
		if cb.velocity.length() > MIN_SPEED * LAND_MARGIN:
			cb.velocity = cb.velocity.bounce(normal)
			cb.velocity *= BOUNCE_DRAG
		else:
			cb.velocity = Vector2.ZERO
			# Align to surface
			cb.rotation = normal.angle() + 1.5708
			
			LANDED = true
			print("landed")


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	var y_movement = Input.get_action_strength("reverse") - Input.get_action_strength("thrust")
	return Vector2(x_movement, y_movement)
