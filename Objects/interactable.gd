@tool
extends Area2D
class_name Interactable

signal interact

@export var texture: Texture: set=set_texture
@export var allow_item: bool = false

func set_texture(v: Texture):
	texture = v
	for node in get_children():
		if node.owner == null:
			node.queue_free()
	if texture == null:
		return
	var sprite = Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)
	var rect = RectangleShape2D.new()
	rect.extents = sprite.texture.get_size()/2
	var collider = CollisionShape2D.new()
	collider.shape=rect
	add_child(collider)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if not event.is_action_pressed("interact"):
		return
	if not allow_item and Game.inventory.active_item:
		return
	else:
		_interact()
		
func _interact():
	interact.emit()
	
