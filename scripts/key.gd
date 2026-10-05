# Ad Maiorem Dei Gloriam!
class_name Key
extends Node2D

func _on_area_2d_body_entered(player: Player) -> void:
	player.has_key = true
	queue_free()
