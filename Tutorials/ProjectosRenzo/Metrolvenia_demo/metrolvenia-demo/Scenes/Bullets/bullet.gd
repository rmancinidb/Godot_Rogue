extends Area2D

var direction: Vector2
@export var speed : int = 200
const OFFSET = 16

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func setup(pos: Vector2, dir: Vector2):
	position = pos + dir * OFFSET
	direction = dir
