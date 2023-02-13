extends "res://player/states/state.gd"

var velocity

func enter():
	owner.get_node("AnimationPlayer").play("hitstunGr")
	
func update(delta):
	#print(owner.knockback_amount)
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

#see hitstop
func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")


