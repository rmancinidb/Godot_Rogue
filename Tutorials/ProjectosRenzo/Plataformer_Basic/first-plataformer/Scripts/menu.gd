extends Control

func _on_play_buttom_pressed() -> void:
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scene/level1.tscn")


func _on_play_buttom_2_pressed() -> void:
	get_tree().quit()
