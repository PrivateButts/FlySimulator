extends CharacterBody2D

class_name Bullet

## The speed of the bullet in pixels per second.
@export var SPEED: float = 1
## The damage the bullet will do to an enemy.
@export var DAMAGE: float = 10

## The life of the bullet in seconds. 0 means infinite.
@export var LIFE: float = 0
## The number of times the bullet can bounce off walls. 0 means no bouncing, -1 means infinite.
@export var BOUNCES: int = 0

## The sound to play when the bullet hits a wall.
@export var BOUNCE_SOUND: AudioStream


@onready var AUDIO_PLAYER: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var HURT_BOX: HurtBoxComponent = $HurtBoxComponent

var current_life: float = 0


func setup(speed: float, damage: float, life: float=0, bounces: int=0, bounceSound: AudioStream=null):
	SPEED = speed
	velocity = (SPEED * Vector2.UP).rotated(rotation)
	DAMAGE = damage
	LIFE = life
	current_life = life
	BOUNCES = bounces
	BOUNCE_SOUND = bounceSound


func _ready():
	HURT_BOX.damage = DAMAGE
	if BOUNCE_SOUND:
		AUDIO_PLAYER.stream = BOUNCE_SOUND

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

	if collision:
		if BOUNCES > 0:
			BOUNCES -= 1
			velocity = velocity.bounce(collision.get_normal())
			if BOUNCE_SOUND:
				AUDIO_PLAYER.play()
		else:
			queue_free()

	if LIFE > 0:
		current_life -= delta
		if current_life < 0:
			queue_free()
