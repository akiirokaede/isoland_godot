extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect

signal game_entered
signal game_exited

func _ready():
	_on_scene_changed(null, get_tree().get_current_scene())

func change_scene_to_file(target_path):
	var tw = create_tween()
	tw.tween_callback(color_rect.show)
	tw.tween_property(color_rect, "color:a", 1.0, 0.2)
	tw.tween_callback(_change_scene_to_file.bind(target_path))
	tw.tween_property(color_rect, "color:a", 0.0, 0.2)
	tw.tween_callback(color_rect.hide)

func _change_scene_to_file(target_path):
	var old_scene := get_tree().get_current_scene()
	var new_scene := load(target_path).instantiate() as Node
	var root := get_tree().get_root()
	root.remove_child(old_scene)
	root.add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	_on_scene_changed(old_scene, new_scene)
	old_scene.queue_free()

func _on_scene_changed(old_scene: Node, new_scene: Node):
	var was_in_game := old_scene is Scene
	var is_in_game := new_scene is Scene
	if was_in_game != is_in_game:
		if is_in_game:
			game_entered.emit()
		else:
			game_exited.emit()

	var music := "res://assets/Music/PaperWings.mp3"
	if is_in_game and new_scene.music_override:
		music = new_scene.music_override
	SoundManager.play_music(music)