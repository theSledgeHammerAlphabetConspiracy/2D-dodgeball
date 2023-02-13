extends "../motion/on_ground/on_ground.gd"

#might need a max speed variable eventually 
#export(float) var MAX_WALK_SPEED = 450
#export(float) var MAX_RUN_SPEED = 700

func enter():
	owner.get_node("AnimationPlayer").play("hitstunGr")
	
#
#	var input_direction = get_input_direction()
#	update_look_direction(input_direction)
#	owner.get_node("AnimationPlayer").play("walk")

#func handle_input(event):
#	pass
#	return .handle_input(event)

func update(delta):
	#print(owner.knockback_amount)
#	var input_direction = get_input_direction()
#	if not input_direction:
#		emit_signal("finished", "idle")
#	update_look_direction(input_direction)#in motion
#
#	speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED

	var collision_info = move(owner.knockback_amount, owner.knockback_direction)
	if not collision_info:
		return
	#if speed == MAX_RUN_SPEED and collision_info.collider.is_in_group("environment"):
		#return null

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
