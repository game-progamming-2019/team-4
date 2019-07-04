extends Node2D

var player
func _ready():
	player = load("res://Scenes/Player.tscn").instance()
	player.position = Vector2(130, 385)
	add_child(player)
	player.init($Levels/Level_0/World_Map_1/Front_map)
	var cam = Camera2D.new()
	#cam.offset = Vector2(150, 300)
	cam.set_anchor_mode(1)
	cam.current = true
	player.add_child(cam)

func _on_Guard_detected():
	player.position = Vector2(130, 385) 
	print("detected, game over")
