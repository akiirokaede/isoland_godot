extends Node2D
class_name FlagSwitch
@export var flag: String

# flag不存在时默认显示的节点
var default_node: Node2D
# flag存在时显示的节点
var switch_node: Node2D

func _ready() -> void:
	var count := get_child_count()
	if count>0:
		default_node = get_child(0)
	if count>1:
		switch_node = get_child(1)
	Game.flags.connect("changed", _update_nodes)
	_update_nodes()

func _update_nodes() -> void:
	var exists = Game.flags.has(flag)
	if switch_node:
		switch_node.visible = exists
	if default_node:
		default_node.visible = not exists
