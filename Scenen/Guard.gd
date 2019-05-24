extends KinematicBody2D

enum TYPE{GUARD}

export (TYPE) var id = 0

var moveSpeed : int
var moveDist : int

var current_dist = 0

var velocity = Vector2(1, 0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var json
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("./Assets/JsonConfigs/staff.json", file.READ)
	json = parse_json(file.get_as_text())
	file.close()
	createGuard()

func createGuard():
	var sprite : Sprite = $CollisionShape2D/Sprite
	var jsonString = json["guard"][id]
	print(jsonString)
	sprite.texture = load("res://Assets/" + jsonString["tex_src"])
	sprite.hframes = jsonString["hframes"]
	moveDist = jsonString["moveRange"]
	moveSpeed = jsonString["moveSpeed"]
	var timer = Timer.new()
	timer.wait_time = jsonString["waitDuration"]
	add_child(timer)

func _physics_process(delta):
	pass
	