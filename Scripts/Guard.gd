extends KinematicBody2D

enum TYPE{GUARD}

export (TYPE) var id = 0

var moveSpeed : int
var moveDist : int

var current_dist = 0
var velocity = Vector2(1, 0)
var stop = false

var json
var timer

var ready = false

func _ready():
	var file = File.new()
	file.open("./Assets/JsonConfigs/staff.json", file.READ)
	json = parse_json(file.get_as_text())
	file.close()
	#timer = Timer.new()
	#timer.wait_time = json["guard"][id]["waitDuration"]
	#timer.connect("timeout", self, "_on_timeout")
	#add_child(timer)
	createGuard()

func createGuard():
	var sprite : Sprite = $CollisionShape2D/Sprite
	var jsonString = json["guard"][id]
	print(jsonString)
	sprite.texture = load("res://Assets/" + jsonString["tex_src"])
	sprite.hframes = jsonString["hframes"]
	moveDist = jsonString["moveRange"]
	moveSpeed = jsonString["moveSpeed"]
	ready = true

#func _physics_process(delta):
#	if current_dist < moveDist:
#		current_dist += moveSpeed * delta
#	elif current_dist >= moveDist and not stop:
#		timer.start()
#		stop = true	
	
#	if not stop:
#		move_and_slide(velocity * moveSpeed, Vector2.UP)
	
func _on_timeout():
	#velocity.x *= -1
	#current_dist = 0
	#scale.x *= -1
	get_parent().scale.x *= -1
	timer.start()
	#stop = false