extends CharacterBody2D

@export var lungeDistance = 10
@export var lungeDecay = 0.1

@onready var cooldown: Timer = $CooldownTimer
@onready var detectionZone: Area2D = $DetectionZone

var targets: Array[Node2D] = []


func _on_area_2d_body_entered(body: Node2D):
	if body is PlayerCharacter and not body in targets:
		print("Target added: "+body.name)
		targets.append(body)


func _on_area_2d_body_exited(body):
	print("Attempting to remove "+body.name+" from targets")
	targets.erase(body)


func lunge(body: PlayerCharacter):
	print("Lunge!")
	var direction = body.get_global_position() - get_global_position()
	direction = direction.normalized()
	look_at(body.get_global_position())
	velocity = direction * lungeDistance
	cooldown.start()


func _physics_process(_delta):
	move_and_collide(velocity)
	velocity = velocity.lerp(Vector2.ZERO, lungeDecay)

	if targets.size() > 0 and cooldown.is_stopped():
		cooldown.start()
		lunge(targets[0])

