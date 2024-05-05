extends MarginContainer

@onready var label: Label = $Content/Label
@onready var prev: TextureButton = $Content/ItemBar/Prev
@onready var prop: Sprite2D = $Content/ItemBar/Use/Prop
@onready var hand: Sprite2D = $Content/ItemBar/Use/Hand
@onready var next: TextureButton = $Content/ItemBar/Next
@onready var timer: Timer = $Content/Label/Timer

var _hand_outro : Tween
var _label_outro : Tween

func _ready() -> void:
	#Game.inventory.add_item(preload("res://Items/key.tres"))
	#Game.inventory.add_item(preload("res://Items/mail.tres"))
	hand.modulate.a = 0.0
	hand.hide()
	label.modulate.a = 0.0
	label.hide()
	Game.inventory.connect("changed", _update_ui)
	_update_ui(true)

func _update_ui(is_init:=false):
	var count = Game.inventory.get_item_count()
	prev.disabled = count<2
	next.disabled = count<2
	hand.visible = count>0
	label.visible = count>0
	visible = count>0
	var item = Game.inventory.get_current_item()
	if not item:
		return
	label.text = item.description
	prop.texture = item.prop_texture
	if is_init:
		return
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tw.tween_property(prop, "scale", Vector2.ONE, 0.15).from(Vector2.ZERO)
	_show_label()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and Game.inventory.active_item:
		Game.inventory.set_deferred("active_item", null)
		#hand.hide()
		_hand_outro = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		_hand_outro.set_parallel()
		_hand_outro.tween_property(hand, "scale", Vector2.ONE*3, 0.15)
		_hand_outro.tween_property(hand, "modulate:a", 0.0, 0.15)
		_hand_outro.chain().tween_callback(hand.hide)

func _on_prev_pressed() -> void:
	Game.inventory.select_prev()
	_show_label()


func _on_use_pressed() -> void:
	Game.inventory.active_item = Game.inventory.get_current_item()
	hand.show()
	if _hand_outro and _hand_outro.is_valid():
		_hand_outro.kill()
		_hand_outro = null
	var tw := create_tween()
	tw.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tw.tween_property(hand, "scale", Vector2.ONE, 0.15).from(Vector2.ZERO)
	tw.tween_property(hand, "modulate:a", 1.0, 0.15)
	_show_label()

func _on_next_pressed() -> void:
	Game.inventory.select_next()
	_show_label()

func _show_label():
	if _label_outro and _label_outro.is_valid():
		_label_outro.kill()
		_label_outro = null
	label.show()
	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(label, "modulate:a", 1.0, 0.2)
	tw.tween_callback(timer.start)

func _on_timer_timeout() -> void:
	_label_outro = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_label_outro.tween_property(label, "modulate:a", 0.0, 0.2)
	_label_outro.tween_callback(label.hide)
