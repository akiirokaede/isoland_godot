extends CanvasLayer

func _ready() -> void:
	SceneChanger.connect("game_entered", show)
	SceneChanger.connect("game_exited", hide)
	visible = get_tree().current_scene is Scene

func _on_menu_pressed() -> void:
	Game.back_to_title()
