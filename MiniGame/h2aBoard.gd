@tool
extends Node2D

const SLOT_TEXTURE = preload("res://assets/H2A/CIRCLE.png")
const LINE_TEXTURE = preload("res://assets/H2A/CIRCLELINE.png")

@export var radius := 100.0 :set=set_radius
@export var config : H2AConfig :set=set_config
var _stone_map := {}

func _draw() -> void:
	for slot in H2AConfig.Slot.size():
		draw_texture(SLOT_TEXTURE, _get_slot_position(slot) - SLOT_TEXTURE.get_size()/2)

func set_radius(value: float) -> void:
	radius = value
	queue_redraw()

func set_config(value: H2AConfig) -> void:
	if config and config.is_connected("changed", _update_board):
		config.disconnect("changed", _update_board)
	config = value
	if config and not config.is_connected("changed", _update_board):
		config.connect("changed", _update_board)
	_update_board()

func reset():
	for stone in _stone_map.values():
		_move_stone(stone, config.placements[stone.target_slot])

func _update_board() -> void:
	for node in get_children():
		if node.owner == null:
			node.queue_free()
	if not config:
		return
	for src in H2AConfig.Slot.size():
		for dst in range(src+1, H2AConfig.Slot.size()):
			if not dst in config.connections[src]:
				continue
			var line := Line2D.new()
			add_child(line)
			line.add_point(_get_slot_position(src))
			line.add_point(_get_slot_position(dst))
			line.width=LINE_TEXTURE.get_size().y
			line.texture=LINE_TEXTURE
			line.texture_mode=Line2D.LINE_TEXTURE_TILE
			line.default_color=Color.WHITE
			line.show_behind_parent=true
	for slot in range(1, H2AConfig.Slot.size()):
		var stone:=H2aStone.new()
		add_child(stone)
		stone.target_slot=slot
		stone.current_slot=config.placements[slot]
		stone.position=_get_slot_position(stone.current_slot)
		_stone_map[slot]=stone
		stone.connect("interact", _request_move.bind(stone))

func _get_slot_position(slot: int) -> Vector2:
	return Vector2.DOWN.rotated(TAU/H2AConfig.Slot.size()*slot)*radius

func _request_move(stone: H2aStone) -> void:
	var availiable := H2AConfig.Slot.values()
	for s in _stone_map.values():
		availiable.erase(s.current_slot)
	assert(availiable.size() == 1)
	var availiable_slot := availiable.front() as int
	if availiable_slot in config.connections[stone.current_slot]:
		_move_stone(stone, availiable_slot)

func _move_stone(stone: H2aStone, target_slot: int) -> void:
	stone.current_slot=target_slot
	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(stone, "position", _get_slot_position(target_slot), 0.2)
	tw.tween_interval(1.0)
	tw.tween_callback(_check)

func _check() -> void:
	for stone in _stone_map.values():
		if stone.current_slot != stone.target_slot:
			return
	Game.flags.add("h2a_unlocked")
	SceneChanger.change_scene_to_file("res://Scenes/h2.tscn")
