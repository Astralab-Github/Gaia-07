extends Control

func _process(_delta):
	$ToolbarBG/ScrapIcon/ScrapAmount.set_text(str(Globals.scrap))

func _on_line_turret_button_down():
	Globals.spawnTowersWithID = 0

func _on_crowd_turret_button_down():
	Globals.spawnTowersWithID = 1

func _on_prec_turret_button_down():
	Globals.spawnTowersWithID = 2

func _on_shield_gen_button_down():
	Globals.spawnTowersWithID = 3

func _on_rally_unit_button_down():
	Globals.spawnTowersWithID = 4
