extends Node2D

var player
func _ready():
	player = load("res://Scenes/Player.tscn").instance()
	player.position = $SpawnPoint.position
	add_child(player)
	player.init($Levels/Level_0/World_Map_1/Front_map)
	var cam = Camera2D.new()
	#cam.offset = Vector2(150, 300)
	cam.set_anchor_mode(1)
	cam.current = true
	player.add_child(cam)
	cam.smoothing_enabled = true
	cam.zoom.x = 0.5
	cam.zoom.y = 0.5

func _on_Guard_detected():
	player.position = Vector2(130, 385) 
	print("detected, game over")
