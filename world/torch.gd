extends AnimatedSprite

onready var light = get_node("Lightsource")
onready var tween = get_node("Tween")

func _ready():
	tween.interpolate_property(light, "radius", 32, 12, 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(light, "radius", 12, 24, 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.interpolate_property(light, "radius", 24, 32, 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
