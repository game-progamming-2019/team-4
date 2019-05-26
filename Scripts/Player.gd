extends KinematicBody2D

export var speed : int = 200
export var jumpforce : int = 600
export var gravity : int = 1200

var velocity = Vector2()

func get_input():
	velocity.x = 0
	if Input.is_action_just_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_just_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_just_pressed("ui_select"):
		velocity.y = -jumpforce
	if Input.is_action_just_pressed("ui_down"):
		pass

func _physics_process(delta):
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)