extends Node2D

var bullet_scene = preload('res://Scenes/Bullets/bullet.tscn')

func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	#This transform the scene into a instance (instance is the unique bullet, no the 'mother bullet'
	var bullet = bullet_scene.instantiate()
	$Bullets.add_child(bullet)
	bullet.setup(pos, dir)
