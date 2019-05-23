extends Area2D

var target = null
var hit_pos = []
var flipped = false

func _on_body_entered(body):
	if(body.name == "Player"):
		target = body
		scale.x *= -1
		flipped = true

func _on_body_exited(body):
	if(body.name == "Player"):
		target = null

func _draw():
	if target:
		for hit in hit_pos:
			var laser_color = Color(255, 0, 0)
			draw_circle(hit - position, 5, laser_color)
			draw_line(Vector2(), hit - position, laser_color)

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	update()
	if target:
		hit_pos = []
		var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
		var nw = target.position - target_extents
		var se = target.position + target_extents
		var ne = target.position + Vector2(target_extents.x, -target_extents.y)
		var sw = target.position + Vector2(-target_extents.x, target_extents.y)
		for pos in [target.position, nw, ne, se, sw]:
			var result = space_state.intersect_ray(position, pos, [self], collision_mask)
			if result:
				hit_pos.append(result.position)
				print(hit_pos)
				if result.collider.name == "Player":
					print("hit")
