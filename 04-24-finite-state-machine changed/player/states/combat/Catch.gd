extends "../motion/on_ground/on_ground.gd"

export var chargeable: bool = false
export var advance: bool = false
var locked_direction:= Vector2()
export var locked_speed:float=0.0
var chargespeed:float=0.0

func enter():

	locked_speed = 0
	advance = false
#
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	owner.get_node("AnimationPlayer").play("catch")

#func handle_input(event):
#	pass
#	return .handle_input(event)

func update(delta):
	if Input.is_action_pressed("B"+owner.player_team) and chargeable == true:
		owner.get_node("AnimationPlayer").stop(false)
		chargespeed +=10.0
	else:
		if chargespeed >= 600:
			chargespeed = 600
		owner.get_node("AnimationPlayer").play()
		
		
#	var collision_info = move(owner.knockback_amount, owner.knockback_direction)
#	if not collision_info:
#		return
	
func move(speed, direction):
	#velocity = direction.normalized() * speed
	velocity = (direction.normalized()*Vector2(1,.5)) * speed
	#print(owner.knockback_amount)
	#trying this in the animation player in the capture type
	#owner.knockback_amount = owner.knockback_amount *.95# -= 10# owner.knockback_amount *.1
	#clamp?
	
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)

func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")
