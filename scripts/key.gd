# Ad Maiorem Dei Gloriam!
class_name Key
extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D

func _on_area_2d_body_entered(player: Player) -> void:
	player.has_key = true
	player.trigger_collected_item_effect()
	%Area2D.body_entered.disconnect(_on_area_2d_body_entered)
	_destroy()
	
func _destroy() -> void:
	particles.emitting = true
	
	%AnimatedSprite2D.scale = Vector2(1.4, 0.6)
	%AnimatedSprite2D.modulate = Color(20.0, 20.0, 20.0, 1.0)
	
	var tween: Tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(self, "position", Vector2(position.x, position.y - 5), 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(%PointLight2D, "texture_scale", 0.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(%AnimatedSprite2D, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(%AnimatedSprite2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.07)
	tween.finished.connect(queue_free)
