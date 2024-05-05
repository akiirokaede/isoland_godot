@tool
extends Interactable
class_name SceneItem

@export var item: Item: set=set_item

func _ready() -> void:
	# 编辑器内禁用
	if Engine.is_editor_hint():
		return
	# 游戏内逻辑
	if Game.flags.has(_get_flag()):
		hide()
		queue_free()

func set_item(v: Item):
	item = v
	set_texture(item.scene_texture if item else null)
	notify_property_list_changed()

func _interact():
	super._interact()
	Game.flags.add(_get_flag())
	Game.inventory.add_item(item)
	var sprite = Sprite2D.new()
	sprite.texture = item.scene_texture
	get_parent().add_child(sprite)
	sprite.global_position = global_position
	var tw = sprite.create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tw.tween_property(sprite, "scale", Vector2.ZERO, 0.15)
	tw.tween_callback(sprite.queue_free)
	queue_free()

func _get_flag():
	return "picked"+item.resource_path.get_file()
