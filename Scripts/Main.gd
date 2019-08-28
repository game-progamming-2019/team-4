extends Node2D

var player
var currentLevel : int = 1
var levelsArr = [
	"res://Scenes/Levels/Level_0_Map.tscn",
	"res://Scenes/Levels/Level_1.tscn",
	"res://Scenes/Levels/Level_2.tscn",
	"res://Scenes/Levels/Level_3.tscn"
	]
var outline = "res://Assets/Sprites/Outline.png"

func _ready():
	print(levelsArr[currentLevel])
	$Levels.add_child(load(levelsArr[currentLevel]).instance(), true)
	get_node("Levels/Level_" + str(currentLevel)).connect("level_complete", self, "_on_level_complete")
	get_node("Levels/Level_" + str(currentLevel)).connect("player_detected", self, "_on_player_detected")
	player = load("res://Scenes/Player.tscn").instance()
	player.position = $SpawnPoint.position
	add_child(player)
	player.init(get_node("Levels/Level_" + str(currentLevel) + "/Front_map"))
	var cam = Camera2D.new()
	cam.set_anchor_mode(1)
	cam.current = true
	player.add_child(cam)
	cam.smoothing_enabled = true
	cam.zoom.x = 0.5
	cam.zoom.y = 0.5

func _on_level_complete():
	get_node("Levels/Level_" + str(currentLevel)).queue_free()
	currentLevel = currentLevel + 1
	$Levels.add_child(load(levelsArr[currentLevel]).instance(), true)
	player.init(get_node("Levels/Level_" + str(currentLevel) + "/Front_map"))
	get_node("Levels/Level_" + str(currentLevel)).connect("level_complete", self, "_on_level_complete")
	get_node("Levels/Level_" + str(currentLevel)).connect("player_detected", self, "_on_player_detected")
	player.position = $SpawnPoint.position

func _on_player_detected():
	if player.position != $SpawnPoint.position:
		var detected : Sprite = Sprite.new()
		detected.texture = load(outline)
		detected.position = player.position
		get_node("Levels/Level_" + str(currentLevel) + "/PlayerResets").add_child(detected)
		player.position = $SpawnPoint.position 
		print("detected, game over")
	pass