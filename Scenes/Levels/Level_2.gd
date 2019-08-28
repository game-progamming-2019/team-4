extends Node2D

signal level_complete
signal player_detected

func _ready():
	pass # Replace with function body.


func _on_Player_detected():
	emit_signal("player_detected")
	pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("level_complete")
	pass # Replace with function body.
