extends Node2D

## Prefab scene that will be instanced when the weapon is fired.
@export var BULLET: PackedScene

## The speed of the BULLET in pixels per second.
@export var BULLET_SPEED: float = 1
## The damage the BULLET will do to an enemy.
@export var BULLET_DAMAGE: float = 10
## The rate of fire in seconds.
@export var BULLET_FIRE_RATE: float = 1

## The life of the BULLET in seconds. 0 means infinite.
@export var BULLET_LIFE: float = 0
## The number of times the BULLET can bounce off walls. 0 means no bouncing, -1 means infinite.
@export var BULLET_BOUNCES: int = 0

## The spread of the bullets in degrees. Setting a spread of 180 will fire in a cone from -90 to 90 degrees.
@export var BULLET_SPREAD: float = 0
@export var RANDOM_SPREAD: bool = false

## The number of bullets to fire at once.
@export var BULLET_COUNT: int = 1

## The sound to play when the weapon is fired.
@export var FIRE_SOUND: AudioStream
## The sound to play when the BULLET hits a wall.
@export var BOUNCE_SOUND: AudioStream

@onready var MUZZLE_POSITION: Node2D = $Muzzle
@onready var AUDIO_PLAYER: AudioStreamPlayer2D = $AudioStreamPlayer2D


var timer: Timer


func _ready():
	if(BULLET == null):
		print("No BULLET prefab set for weapon " + name)
		return
	
	timer = Timer.new()
	timer.wait_time = BULLET_FIRE_RATE
	timer.connect("timeout", on_timer_timeout)
	add_child(timer)
	timer.start()

	if FIRE_SOUND:
		AUDIO_PLAYER.stream = FIRE_SOUND


func on_timer_timeout():
	fire()


func fire():
	print("Firing weapon " + name)

	if FIRE_SOUND:
		AUDIO_PLAYER.play()

	for i in range(BULLET_COUNT):
		var bulletInstance = BULLET.instantiate() as Bullet
		bulletInstance.position = MUZZLE_POSITION.global_position
		if(RANDOM_SPREAD):
			bulletInstance.rotation = MUZZLE_POSITION.global_rotation + deg_to_rad(
				randf_range(-BULLET_SPREAD / 2, BULLET_SPREAD / 2)
			)
		else:
			bulletInstance.rotation = MUZZLE_POSITION.global_rotation + deg_to_rad(
				-BULLET_SPREAD / 2 + BULLET_SPREAD / (BULLET_COUNT - 1) * i
			)

		bulletInstance.setup(
			BULLET_SPEED,
			BULLET_DAMAGE,
			BULLET_LIFE,
			BULLET_BOUNCES,
			BOUNCE_SOUND
		)
		get_parent().add_child(bulletInstance)

