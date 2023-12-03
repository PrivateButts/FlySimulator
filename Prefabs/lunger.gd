extends CharacterBody2D

@export var lungeDistance = 10
@export var lungeDecay = 0.1

@onready var cooldown: Timer = $CooldownTimer



func lunge(body: Node2D):
	print("Lunge!")
	var direction = body.get_global_position() - get_global_position()
	direction = direction.normalized()
	velocity = direction * lungeDistance
	cooldown.start()


func _physics_process(_delta):
	move_and_collide(velocity)
	velocity = velocity.lerp(Vector2.ZERO, lungeDecay)


func _on_tracking_targets(bodies: Array[Node2D]):
	look_at(bodies[0].get_global_position())
	if cooldown.is_stopped():
		cooldown.start()
		lunge(bodies[0])
