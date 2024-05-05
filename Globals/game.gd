extends Node
const SAVE_PATH := "user://data.sav"

class Flags:
	signal changed
	var _flags = []
	func has(flag: String):
		return flag in _flags
	func add(flag: String):
		if flag in _flags:
			return
		_flags.append(flag)
		changed.emit()
	func to_dict():
		return {
			flags=_flags
		}
	func from_dict(dict: Dictionary):
		_flags = dict["flags"]
		changed.emit()
	func reset():
		_flags.clear()
		changed.emit()


class Inventory:
	signal changed
	
	var active_item : Item
	
	var _items := []
	var _current_item_index := -1
	
	func get_item_count():
		return _items.size()
	func get_current_item():
		if _current_item_index==-1:
			return
		else:
			return _items[_current_item_index]
	func add_item(item: Item):
		if item in _items:
			return
		else:
			_items.append(item)
			_current_item_index = _items.size()-1
			changed.emit()
	func remove_item(item: Item):
		var index = _items.find(item)
		if index==-1:
			return
		else:
			_items.remove_at(index)
			if _current_item_index>=_items.size():
				_current_item_index=0
			if _items.size()==0:
				_current_item_index=-1
			changed.emit()
	func select_next():
		if _current_item_index == -1:
			return
		else:
			_current_item_index = (_current_item_index+1)%_items.size()
			changed.emit()
	func select_prev():
		if _current_item_index == -1:
			return
		else:
			_current_item_index = (_current_item_index-1+_items.size())%_items.size()
			changed.emit()
	func to_dict():
		var names := []
		for item in _items:
			var path := item.resource_path as String
			names.append(path.get_file().get_basename())
		return {
			items=names,
			current_item_index=_current_item_index
		}
	func from_dict(dict: Dictionary):
		_current_item_index = dict.current_item_index
		_items.clear()
		for name in dict.items:
			_items.append(load("res://Items/"+name+".tres"))
		changed.emit()
	func reset():
		_current_item_index = -1
		_items.clear()
		changed.emit()
var flags := Flags.new()
var inventory := Inventory.new()

func save_game():
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		return
	var data := {
		inventory=inventory.to_dict(),
		flags=flags.to_dict(),
		current_scene=get_tree().current_scene.scene_file_path.get_file().get_basename()
	}
	var json = JSON.stringify(data)
	file.store_string(json)

func load_game():
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var json = file.get_as_text()
	var data = JSON.parse_string(json) as Dictionary
	inventory.from_dict(data.inventory)
	flags.from_dict(data.flags)
	SceneChanger.change_scene_to_file("res://Scenes/"+data.current_scene+".tscn")

func new_game():
	flags.reset()
	inventory.reset()
	SceneChanger.change_scene_to_file("res://Scenes/h1.tscn")

func has_save_file()->bool:
	return FileAccess.file_exists(SAVE_PATH)

func back_to_title():
	save_game()
	SceneChanger.change_scene_to_file("res://UI/title_screen.tscn")
