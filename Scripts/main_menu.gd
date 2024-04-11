extends Control

const LEVEL_ONE: PackedScene = preload("res://Scenes/level_1.tscn")

func _ready():
	$Splash.visible = true
	$VHS.visible = true
	$Sounds/Intro.play()
	await get_tree().create_timer(2).timeout
	await get_tree().create_tween().tween_property($Splash, "modulate:a", 0, 1).finished
	$Splash.queue_free()

func _on_play_button_pressed():
	$PlayButton.disabled = true
	$Sounds/Click.play()
	
	for star in $StarNode.get_children():
		star.process_material.gravity = Vector3(-30, -200, 0)
		star.emitting = false
	
	get_tree().create_tween().tween_property($PlayButton, "modulate:a", 0, 1); $PlayButtonShadow.queue_free()
	get_tree().create_tween().tween_property($ExitButton, "modulate:a", 0, 1); $ExitButtonShadow.queue_free()
	await get_tree().create_tween().tween_property($Title, "modulate:a", 0, 1).finished
	$PlayButton.queue_free(); $ExitButton.queue_free()
	
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_packed(LEVEL_ONE)

func _on_exit_button_pressed():
	$Sounds/Click.play()
	get_tree().quit()

func _on_button_mouse_entered():
	$Sounds/HoverOn.play()

func _on_button_mouse_exited():
	$Sounds/HoverOff.play()
