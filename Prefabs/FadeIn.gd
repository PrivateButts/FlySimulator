extends PanelContainer

@export var duration: float = 5


func _ready():
	self.modulate = Color.TRANSPARENT
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, duration).set_trans(Tween.TRANS_SINE)
