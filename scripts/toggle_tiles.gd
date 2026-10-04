# Ad Maiorem Dei Gloriam!
class_name ToggleTiles
extends TileMapLayer

var _active: bool = true
@export var color_when_disabled: float = 0.4

func toggle_disable() -> void:
	if _active: _deactivate()
	else: _activate()
	
func _activate() -> void:
	_active = true
	modulate.a = 1.0
	tile_set.set_occlusion_layer_light_mask(0, 1)
	tile_set.set_physics_layer_collision_layer(0, 1)

func _deactivate() -> void:
	_active = false
	modulate.a = color_when_disabled
	tile_set.set_physics_layer_collision_layer(0, 0)
	tile_set.set_occlusion_layer_light_mask(0, 0)
