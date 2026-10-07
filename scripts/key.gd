# Ad Maiorem Dei Gloriam!
class_name Key
extends Node2D


func _on_area_2d_body_entered(player: Player) -> void:
	player.has_key = true
	_destroy()
	
func _destroy() -> void:
	
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", Vector2(position.x, position.y - 5), 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(%PointLight2D, "texture_scale", 0.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(%AnimatedSprite2D, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(queue_free)
