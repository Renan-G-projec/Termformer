# Ad Maiorem Dei Gloriam!
extends Area2D

var tween: Tween = null


func _on_body_entered(body: Node2D) -> void:
	visible = true
	
	if tween:
		tween.kill()
	tween = create_tween()
	
	%AnimatedSprite2D.scale = Vector2.ZERO
	await tween.tween_property(%AnimatedSprite2D, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).finished
	%AnimatedSprite2D.play()
	await %AnimatedSprite2D.animation_finished
	%AnimatedSprite2D.play_backwards()


func _on_body_exited(body: Node2D) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
	%AnimatedSprite2D.scale = Vector2.ONE
	await tween.tween_property(%AnimatedSprite2D, "scale", Vector2.ZERO, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).finished
	visible = false
