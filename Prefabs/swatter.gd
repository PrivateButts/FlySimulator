extends Node2D

@export var SWING_TIME: float = 0.5
@export var RESET_TIME: float = 1
@onready var ROTATION_LIMIT: float = rotation

var CAN_SWING: bool = true

func _on_area_2d_body_entered(body: Node2D):
	if body is PlayerCharacter:
		swing()


func swing():
	if not CAN_SWING:
		return
	CAN_SWING = false
	var tween = create_tween()
	tween.tween_property($Holder, "rotation", ROTATION_LIMIT * -1, SWING_TIME)
	tween.tween_callback(reset_swing)


func reset_swing():
	var tween = create_tween()
	tween.tween_property($Holder, "rotation", ROTATION_LIMIT, RESET_TIME)
	tween.tween_callback(func(): CAN_SWING = true)
