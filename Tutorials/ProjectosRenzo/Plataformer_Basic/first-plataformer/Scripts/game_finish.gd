extends Control

@onready var score_label : Label = $"Label(score)2"

func _ready() -> void:
	score_label.text = 'score: ' + str(PlayerStats.score)

func _on_button_replay_pressed() -> void:
	PlayerStats.score = 0
	PlayerStats.health = 3
	get_tree().change_scene_to_file("res://Scene/level1.tscn")


func _on_button_2_quit_pressed() -> void:
	get_tree().quit()
