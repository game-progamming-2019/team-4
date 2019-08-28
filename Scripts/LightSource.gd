extends Area2D

class_name LightSource

signal detected

var target = null
var hit_pos = []
export var debug = true

export var distance = 100
export var duration = 5.0
export var waiting_time = 2.0

onready var tween = get_node("Tween")

func _ready():
	_start_movement()

func _on_body_entered(body):

	if(body.name == "Player"):
		target = body

func _on_body_exited(body):
	if(body.name == "Player"):
		target = null

func _draw():
	if debug:
		if target:
			for hit in hit_pos:
				var laser_color = Color(255, 0, 0)
				draw_circle(hit - position, 5, laser_color)
				draw_line(Vector2(), hit - position, laser_color)

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	if $Guard.ready:
		#$Guard.timer.start()
		$Guard.ready = false
			
	if target:
		hit_pos = []
		var target_extents = target.get_node('CollisionShapeNormal').shape.extents
		var nw = target.position - target_extents
		var se = target.position + target_extents
		var ne = target.position + Vector2(target_extents.x, -target_extents.y)
		var sw = target.position + Vector2(-target_extents.x, target_extents.y)

		for pos in [target.position, nw, ne, se, sw]:
			var result = space_state.intersect_ray(position, pos, [self], collision_mask)
			if result:
				hit_pos.append(result.position)
				if result.collider.name == "Player":
					emit_signal("detected")

func _start_movement():
	
	tween.interpolate_property(
		self, "position", 
		self.position, self.position + Vector2(distance,0), duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, waiting_time)
	
	tween.interpolate_property(
		self, "position", 
		self.position + Vector2(distance,0), self.position, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + 2 * waiting_time)
		
	tween.start()

func _on_step(object, key):
	scale.x = scale.x * (-1)