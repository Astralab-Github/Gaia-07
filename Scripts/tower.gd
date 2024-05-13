extends Area2D

@onready var towerId = Globals.spawnTowersWithID # 0: Line, 1: Crowd, 2: Prec, 3: SG, 4: RU
var currentTower: AnimatedSprite2D

const BULLET: PackedScene = preload("res://Scenes/bullet.tscn")

const LINE_TURRET_COOLDOWN: float = 0.7

var firing: bool = false

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
			$RallyUnitPulse.emitting = true
	currentTower.visible = true
	currentTower.play("idle")
	
func _process(_delta):
	match towerId:
		0:
			if not firing and $Linecast.get_collider() and $Linecast.get_collider().name == "Slime":
				firing = true
				var target_pos: Vector2 = $Linecast.get_collider().global_position
				
				var bullet = BULLET.instantiate()
				add_child(bullet)
				bullet.position += Vector2(5,5)
				bullet.look_at(target_pos)
				
				await get_tree().create_tween().tween_property(bullet, "global_position", target_pos, 0.2).finished
				bullet.queue_free()
				
				await get_tree().create_timer(LINE_TURRET_COOLDOWN).timeout
				firing = false
