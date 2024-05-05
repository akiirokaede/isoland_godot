extends Sprite2D
class_name Scene
@export_file("*.mp3") var music_override := ""

func _ready() -> void:
	var tw = create_tween()
	tw.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "scale", Vector2.ONE, 0.3).from(Vector2.ONE*1.05)
