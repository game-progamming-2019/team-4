extends KinematicBody2D

export var walkspeed = 200
export var gravity = 750
export var jumpspeed = -350
export var runMultiplier = 1.5

var velocity = Vector2()
var jumping = false
var walljump = false
var wall_right = false
var wall_left = false
var can_walk = true
var crouching = false

var tilemap : TileMap

func init(_tilemap : TileMap):
	tilemap = _tilemap
	print(_tilemap)
	pass

func get_Input():
	velocity.x = 0
	
	if Input.is_key_pressed(KEY_A) and not Input.is_key_pressed(KEY_S):	
		if Input.is_key_pressed(KEY_SHIFT):
			velocity.x -= walkspeed * runMultiplier
			$icon.flip_h = true
			if is_free_on_top() < 0:
				$icon/AnimationPlayer.playback_speed = 4
				$icon/AnimationPlayer.play("walk")
		else:
			velocity.x -= walkspeed
			$icon.flip_h = true
			if is_free_on_top() < 0:
				$icon/AnimationPlayer.playback_speed = 2
				$icon/AnimationPlayer.play("walk")
		
	elif Input.is_key_pressed(KEY_D) and not Input.is_key_pressed(KEY_S):
		if Input.is_key_pressed(KEY_SHIFT):
			velocity.x += walkspeed * runMultiplier
			$icon.flip_h = false
			if is_free_on_top() < 0:
				$icon/AnimationPlayer.playback_speed = 4
				$icon/AnimationPlayer.play("walk")
		else:
			velocity.x += walkspeed
			$icon.flip_h = false
			if is_free_on_top() < 0:
				$icon/AnimationPlayer.playback_speed = 2
				$icon/AnimationPlayer.play("walk")
			
	if Input.is_key_pressed(KEY_S) and is_on_floor():
		if Input.is_key_pressed(KEY_D):
			$icon.flip_h = false
			velocity.x += walkspeed
		elif Input.is_key_pressed(KEY_A):
			$icon.flip_h = true
			velocity.x -= walkspeed
		crouching = true
		$icon/AnimationPlayer.play("Crouch")
		$icon/AnimationPlayer.playback_speed = 2 
			
	if Input.is_key_pressed(KEY_SPACE) and not jumping and is_on_floor():
		velocity.y = jumpspeed
		jumping = true
		if is_free_on_top() < 0:
			crouching = false
			$icon/AnimationPlayer.play("idle")

	if not Input.is_key_pressed(KEY_S) and not Input.is_key_pressed(KEY_A) and not Input.is_key_pressed(KEY_D) and is_free_on_top() < 0:
		$icon/AnimationPlayer.play("idle")
		
func is_free_on_top():
	var mapPos = tilemap.world_to_map(position)
	mapPos.y -= 1
	return tilemap.get_cellv(mapPos)
	
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
	
	if crouching:
		$CollisionShapeCrouching.disabled = false
		$CollisionShapeNormal.disabled = true
		if is_free_on_top() < 0:
			crouching = false
	elif not crouching:
		$CollisionShapeCrouching.disabled = true
		$CollisionShapeNormal.disabled = false
			
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