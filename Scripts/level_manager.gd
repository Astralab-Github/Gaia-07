extends Node2D

@export var panCameraTo: Node2D
@export var dialogueBox: TextureRect

const VHS_FILTER: PackedScene = preload("res://Scenes/vhs.tscn")
const TYPE_SPEED: float = 0.05
const DIALOGUE: Dictionary = {
	"Level1": [
		"Nathan:Ugh... My head.",
		"Nathan:How long till we get there doc? I think I'm getting space queezy...",
		"Dr. Rackham:You've only been on this ship for a week!",
		"Dr. Rackham:My first mission was 3 years ago, I've had to put up with this stuff since.",
		"Nathan:There have barely been any system malfunctions at all!",
		"Nathan:Other than the soda machine...",
		"Nathan:I didn't think that this \"extremely important space mission\" I was chosen for was going to go like this.",
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

func _ready():
	$CanvasLayer.visible = true
	
	var vhsFilter = VHS_FILTER.instantiate(); $CanvasLayer.add_child(vhsFilter)
	
	await get_tree().create_tween().tween_property($Camera, "position", panCameraTo.position, 1).finished
	
	# Run Dialogue
	var currentDialogue = DIALOGUE[get_tree().get_root().get_child(0).name]
	await get_tree().create_tween().tween_property(dialogueBox, "modulate:a", 0.8, 1).finished
	for text in currentDialogue:
		var splitText = text.split(":")
		dialogueBox.get_node("Speaker").set_text(splitText[0])
		await typewriter(splitText[1], dialogueBox.get_node("Text"))
	await get_tree().create_tween().tween_property(dialogueBox, "modulate:a", 0, 1).finished
	
	# Run Game
