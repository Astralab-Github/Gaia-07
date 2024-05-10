extends Node2D

@export var panCameraTo: Node2D
@export var dialogueBox: TextureRect
@export var enemyPaths: Array[Path2D]
@export var panicLights: Array[PointLight2D]

var currentMousePos: Vector2i
var canPlace: bool = false

const SLIME: PackedScene = preload("res://Scenes/slime.tscn")
const VHS_FILTER: PackedScene = preload("res://Scenes/vhs.tscn")
const TOWER: PackedScene = preload("res://Scenes/tower.tscn")
const TYPE_SPEED: float = 0.035
const DIALOGUE: Dictionary = {
	"Level1": [
		"Nathan:Ugh... My head.",
		"Nathan:How long till we get there doc? I think I'm getting space queezy...",
		"Dr. Rackham:You've only been on this ship for a week!",
		"Dr. Rackham:My first mission was 3 years ago, I've had to put up with this stuff since.",
		"Nathan:There have barely been any system malfunctions at all!",
		"Nathan:Other than the soda machine...",
		"Nathan:I didn't think that this \"extremely important space mission\" I was chosen for was going to be so boring.",
		"Dr. Rackham:Stop thinking so demoralizingly!",
		"Dr. Rackham:Planet Adorno has some minerals that some societies could only dream of having.",
		"Nathan:I guess...",
		"Dr. Rackham: Also, I'm very focused on my current endeavors. I need to focus.",
		"Nathan:What'ya making there? Some potion to make you big and strong?",
		"Dr. Rackham:I'm quite unsure actually.",
		"Dr. Rackham: One last drop should do the trick...",
		" :KABOOM",
		"Nathan:Ugh... what happened?",
		"Nathan:All I remember... an explosion in Dr. Rackham's room...",
		"Nathan:Uh oh."
	]
}

func typewriter(text, labelObject):
	var splitText = text.split()
	labelObject.set_text("")
	
	for chara in splitText:
		var currentText = labelObject.get_text()
		labelObject.set_text(currentText + chara)
		await get_tree().create_timer(TYPE_SPEED).timeout
	
	await get_tree().create_timer(2).timeout

func send_enemy(lane: int, type: int): # type 0: slime
	var pFollow = PathFollow2D.new()
	var enemy
	match type:
		0:
			enemy = SLIME.instantiate()
	pFollow.rotates = false
	pFollow.add_child(enemy)
	enemyPaths[lane].add_child(pFollow)
	enemy.get_node("AnimatedSprite2D").play("default")
	await get_tree().create_tween().tween_property(pFollow, "progress_ratio", 1, enemy.get_meta("Speed")).finished
	await get_tree().create_tween().tween_property(enemy, "global_position", $Reactor.global_position + Vector2(0,120), 1).finished
	

func _ready():
	$CanvasLayer.visible = true
	
	var vhsFilter = VHS_FILTER.instantiate(); $CanvasLayer.add_child(vhsFilter)
	
	# Run Dialogue
	print(get_tree().get_root().get_children())
	var currentDialogue: PackedStringArray = DIALOGUE[Globals.levelName]
	await get_tree().create_tween().tween_property(dialogueBox, "modulate:a", 0.8, 1).finished
	for text in currentDialogue:
		break
		var splitText = text.split(":")
		var speakerText = splitText[0]
		dialogueBox.get_node("Speaker").set_text(speakerText)
		match speakerText:
			"Nathan":
				get_tree().create_tween().tween_property(dialogueBox.get_node("Nathan"), "modulate:a", 1, 0.5)
				get_tree().create_tween().tween_property(dialogueBox.get_node("Rackham"), "modulate:a", .45, 0.5)
			"Dr. Rackham":
				get_tree().create_tween().tween_property(dialogueBox.get_node("Nathan"), "modulate:a", .45, 0.5)
				get_tree().create_tween().tween_property(dialogueBox.get_node("Rackham"), "modulate:a", 1, 0.5)
			" ":
				get_tree().create_tween().tween_property(dialogueBox.get_node("Nathan"), "modulate:a", .45, 0.5)
				get_tree().create_tween().tween_property(dialogueBox.get_node("Rackham"), "modulate:a", .45, 0.5)
		await typewriter(splitText[1], dialogueBox.get_node("Text"))
	await get_tree().create_tween().tween_property(dialogueBox, "modulate:a", 0, 1).finished
	
	# Run Game
	# probably introduce ui with a cool tween and start a little tutorial sequence if its level 1
	# enable the gameloop and tower placing n stuff
	await get_tree().create_tween().tween_property($Camera, "position", panCameraTo.position, 1).finished
	canPlace = true
	
	send_enemy(randi_range(0, len(enemyPaths)-1), 0) # send enemy on any lane, send a slime

func _process(delta):
	for light in panicLights:
		light.rotation_degrees += 200 * delta

func _input(event):
	if event.is_action_pressed("left_click"):
		$IsoTiles.erase_cell(0, $IsoTiles.local_to_map($IsoTiles.get_local_mouse_position()))
	elif event.is_action_pressed("right_click"):
		Globals.spawnTowersWithID = 4; var tower = TOWER.instantiate(); $IsoTiles.add_child(tower)
		tower.position = $IsoTiles.map_to_local($IsoTiles.local_to_map($IsoTiles.get_local_mouse_position())) + Vector2(-.5, -10.5)
