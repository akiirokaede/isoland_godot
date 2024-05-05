extends TextureRect

@onready var load_button = $VBoxContainer/Load

func _ready() -> void:
	load_button.disabled = not Game.has_save_file()

func _on_new_pressed() -> void:
	Game.new_game()

func _on_load_pressed() -> void:
	Game.load_game()

func _on_quit_pressed() -> void:
	get_tree().quit()
