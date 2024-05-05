extends Control

var _dialogs := []
var _current_line := -1

@onready var content: Label = $Content

func _ready() -> void:
	hide()

func show_dialog(dialogs: Array):
	if _current_line==-1 or dialogs!=_dialogs:
		_dialogs = dialogs
		_show_line(0)
		show()
	else:
		_advance()

func _show_line(current_line: int):
	_current_line = current_line
	content.text = _dialogs[current_line]
	var tw = create_tween()
	tw.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "scale", Vector2.ONE, 0.2).from(Vector2.ZERO)

func _advance():
	if _current_line+1 < _dialogs.size():
		_show_line(_current_line+1)
	else:
		_current_line = -1
		hide()

func _on_content_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_advance()
