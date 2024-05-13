extends StaticBody2D

var health: int = 3 # Amount of shots the slime can take

func _ready():
	$AnimatedSprite2D.play("default")
	await get_tree().create_tween().tween_property(get_parent(), "progress_ratio", 1, get_meta("Speed")).finished
	await get_tree().create_tween().tween_property(self, "global_position", Globals.reactor_position + Vector2(0,120), 1).finished

func _on_area_entered(area):
	if area.name == "Bullet":
		if health > 1:
			health -= 1
			modulate.a = 0.5
			await get_tree().create_timer(0.1).timeout
			modulate.a = 1
		else:
			get_parent().queue_free(); queue_free()
			#position = Vector2(10000,10000)
			#await get_tree().create_timer(60).timeout
			#queue_free()
