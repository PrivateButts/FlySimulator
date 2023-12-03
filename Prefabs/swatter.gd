extends Node2D

@export var SWING_TIME: float = 0.5
@export var RESET_TIME: float = 1

@onready var Holder: Node2D = $Holder
@onready var ROTATION_LIMIT: float = Holder.rotation
@onready var Detector: DetectionZoneComponent = $DetectionZoneComponent

var CAN_SWING: bool = true

func _ready():
	for node in get_children():
		print(node.name)


func _on_tracking_targets(_bodies: Array[Node2D]):
	swing()


func swing():
	if not CAN_SWING:
		return
	CAN_SWING = false
	var tween = create_tween()
	tween.tween_property($Holder, "rotation", ROTATION_LIMIT * -1, SWING_TIME)
	tween.tween_callback(reset_swing)
	print("Swinging to "+str(ROTATION_LIMIT * -1))


func reset_swing():
	var tween = create_tween()
	tween.tween_property($Holder, "rotation", ROTATION_LIMIT, RESET_TIME)
	tween.tween_callback(func(): CAN_SWING = true)
	print("Resetting to "+str(ROTATION_LIMIT))
