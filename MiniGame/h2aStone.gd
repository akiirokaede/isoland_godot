@tool
extends Interactable
class_name H2aStone

var target_slot: int :set=set_target_slot
var current_slot: int :set=set_current_slot

func set_target_slot(value: int) -> void:
    target_slot = value
    _update_texure()

func set_current_slot(value: int) -> void:
    current_slot = value
    _update_texure()

func _update_texure() -> void:
    var index:=target_slot
    if target_slot!=current_slot:
        index+=H2AConfig.Slot.size()-1
    set_texture(load("res://assets/H2A/SS_%02d.png"%index))