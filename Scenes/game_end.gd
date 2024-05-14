extends Control

func _ready():
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
