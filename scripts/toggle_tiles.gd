# Ad Maiorem Dei Gloriam!
@tool
class_name ToggleTiles
extends TileMapLayer

@export var active: bool = true:
	set(val):
		active = val
		if val: _activate()
		else: _deactivate()
@export var color_when_disabled: float = 0.4

func toggle_disable() -> void:
	active = !active
	
func _activate() -> void:
	modulate.a = 1.0
	tile_set.set_occlusion_layer_light_mask(0, 1)
	collision_enabled = true

func _deactivate() -> void:
	modulate.a = color_when_disabled
	tile_set.set_occlusion_layer_light_mask(0, 0)
	collision_enabled = false
