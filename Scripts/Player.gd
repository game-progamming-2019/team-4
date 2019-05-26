extends KinematicBody2D

export var walkspeed = 200
export var gravity = 750
export var jumpspeed = -300
export var runMultiplier = 1.5

var velocity = Vector2()
var jumping = false
var walljump = false
var wall_right = false
var wall_left = false
var can_walk = true

#TODO: 	add stammina for running 
#		add idle animation

func get_Input():
	velocity.x = 0	

	if Input.is_key_pressed(KEY_A):	
		if Input.is_key_pressed(KEY_SHIFT):
			velocity.x -= walkspeed * runMultiplier
		else:
			velocity.x -= walkspeed
		
	if Input.is_key_pressed(KEY_D):
		if Input.is_key_pressed(KEY_SHIFT):
			velocity.x += walkspeed * runMultiplier
		else:
			velocity.x += walkspeed

			
		
	if Input.is_key_pressed(KEY_SPACE) and not jumping and is_on_floor():
		velocity.y = jumpspeed
		jumping = true

	#if not Input.action_press("ui_left") and not Input.action_press("ui_right"):
		#animationPlayer.play("idle")

func _physics_process(delta):
	update()
	if can_walk:
		get_Input()
		
	if is_on_floor():
		wall_left = false
		wall_right = false
		can_walk = true
		walljump = false
		if jumping:
			jumping = false
	
	if is_on_wall():
		walljump = false
		
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision and is_on_wall():
			do_walljump(collision.collider)
		if collision and is_on_ceiling():
			velocity.y = 0

func do_walljump(collider):
	
	if collider is TileMap:
		
		if Input.is_key_pressed(KEY_SPACE):
			
			if Input.is_key_pressed(KEY_A) and not wall_left:
				velocity.y = jumpspeed
				velocity.x = -jumpspeed / 2
				walljump = true
				can_walk = false
				wall_right = false
				wall_left = true
				
			elif Input.is_key_pressed(KEY_D) and not wall_right:
				velocity.y = jumpspeed
				velocity.x = jumpspeed/2
				walljump = true
				can_walk = false
				wall_left = false
				wall_right = true