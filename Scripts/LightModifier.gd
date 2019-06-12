extends CanvasModulate

export (float) var day_duration = 0.5 # in Minuten
export (float) var day_start_hour = 10

export var color_day = Color(1.0, 1.0, 1.0, 1.0)
export var color_night = Color(0.2, 0.2, 0.2, 0.7)

export (float) var state_day_start_hour = 8
export (float) var state_night_start_hour = 19

export (float) var state_transition_duration = 1 # in "virtuellen" Stunden


var current_time
var current_day_hour
var current_day_number

var transition_duration

var cycle
enum cycle_state { NIGHT, DAY }


func _ready():

	day_duration = 60 * 60 * day_duration

	current_time = (day_duration / 24) * day_start_hour
	current_day_hour = current_time / (day_duration / 24)

	transition_duration = (((day_duration / 24) * state_transition_duration) / 60)

	if current_day_hour >= state_night_start_hour:
		cycle = cycle_state.NIGHT
		color = color_night
	elif current_day_hour >= state_day_start_hour:
		cycle = cycle_state.DAY
		color = color_day


func _physics_process(delta):
	day_cycle()
	current_time += 1


func day_cycle():
	current_day_hour = current_time / (day_duration / 24)

	if current_time >= day_duration:
		current_time = 0
		current_day_hour = 0

	if current_day_hour >= state_night_start_hour:
		cycle_test(cycle_state.NIGHT)
	elif current_day_hour >= state_day_start_hour:
		cycle_test(cycle_state.DAY)


func cycle_test(new_cycle):
	if cycle != new_cycle:
		cycle = new_cycle
		
		var tween = Tween.new()
		
		get_parent().add_child(tween)
		
		if cycle == cycle_state.NIGHT:
			tween.interpolate_property(self, "color", color_day, color_night, transition_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
			tween.start()

		if cycle == cycle_state.DAY:
			tween.interpolate_property(self, "color", color_night, color_day, transition_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
			tween.start()