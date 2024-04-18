extends Area2D

@onready var towerId = Globals.spawnTowersWithID # 0: Line, 1: Crowd, 2: Prec, 3: SG, 4: RU
var currentTower: AnimatedSprite2D

func _ready():
	match towerId:
		0:
			currentTower = $LineTurret
		1:
			currentTower = $CrowdTurret
		2:
			currentTower = $PrecTurret
		3:
			currentTower = $ShieldGen
		4:
			currentTower = $RallyUnit
	currentTower.visible = true
	currentTower.play("idle")
	
