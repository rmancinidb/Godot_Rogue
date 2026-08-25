# Coin.gd
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that touched the coin has the speed booster method
	if body.has_method("add_speed"):
		body.add_speed(50.0)
		body.scale += Vector2(0.2, 0.2)
		queue_free()  # Delete the coin so it can't be collected twice
