extends "../motion/on_ground/on_ground.gd"

export var chargeable: bool = false
export var advance: bool = false
var locked_direction:= Vector2()
export var locked_speed:float=0.0
var chargespeed:float=0.0

var endable = false

func enter():
	endable = false#huh see below
	locked_speed = 0
	advance = false
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimationPlayer").play("catch")

#func handle_input(event):
#	pass
#	return .handle_input(event)

func update(delta):
	if endable == true:
		if Input.is_action_pressed("jump"+owner.player_team):
			owner.get_node('AnimationPlayer').seek(0.12)
			owner.get_node('AnimationPlayer').stop(false)
		else:
		#if $AnimationPlayer.get_current_animation_position() > 0.05: this doesnt work at all
			owner.get_node('AnimationPlayer').play()
			owner.get_node('catchcooldown').start()
			emit_signal("finished", "idle")
	
	if Input.is_action_pressed("B"+owner.player_team) and chargeable == true:
		owner.get_node("AnimationPlayer").stop(false)
		chargespeed +=10.0
	else:
		if chargespeed >= 600:
			chargespeed = 600
		owner.get_node("AnimationPlayer").play()
	
func move(speed, direction):
	velocity = (direction.normalized()*Vector2(1,.5)) * speed
	
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)

func _on_animation_finished(anim_name):
	owner.cValue = 0
	endable = true#NOT SURE WHAT THIS DOES
	#emit_signal("finished", "idle")
	
func _exit():
	owner.cValue = 0


