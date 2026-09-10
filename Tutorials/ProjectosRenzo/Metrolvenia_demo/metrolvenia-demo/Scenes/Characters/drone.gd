extends CharacterBody2D

var direction : Vector2
var speed := 50
#this implies that any body 2D... including player
var player : CharacterBody2D
var health := 3


func _on_player_detection_area_2d_body_entered(body: Node2D) -> void:
	player = body


func _on_player_detection_area_2d_body_exited(_body: Node2D) -> void:
	player = null


func _physics_process(_delta: float) -> void:
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()
		

func hit():
	health -= 1 
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D.material, 'shader_parameter/Progress', 1.0, 0.3)
	tween.tween_property($AnimatedSprite2D.material, 'shader_parameter/Progress', 0.0, 0.5)
	
