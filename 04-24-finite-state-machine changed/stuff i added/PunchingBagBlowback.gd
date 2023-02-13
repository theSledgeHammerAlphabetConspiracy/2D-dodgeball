extends "res://player/states/state.gd"

var velocity

func enter():
	owner.set_collision_layer_bit(0,false)
	owner.set_collision_mask_bit(0,false)
	owner.get_node("AnimationPlayer").play("blowback")
	
func update(delta):
	#print(owner.knockback_amount)
	var collision_info = move(owner.knockback_amount, owner.knockback_direction)
	if not collision_info:
		return
		
	if collision_info.collider.is_in_group("wall"):
		###HOLY SIT THE LEVEL OF NONSENSE
		#print(collision_info.collider.get_name())
		#print("Vector2"+str(owner.knockback_direction))
		if collision_info.collider.get_name() == "Vector2"+str(owner.knockback_direction):
			#print(owner.knockback_direction)
			emit_signal("finished", "wallbounce")#change this to bounce
		
		#print(collision_info.get_travel())
		#if collision_info.get_normal()*-1 == owner.attack_KB_dir:
			#print("COOOOOOOOL"+str(owner.attack_KB_dir))
		#print("normal"+str(collision_info.get_normal()*-1))
		
		#print("dir" + str(owner.knockback_direction))
		#print(collision_info.get_last_slide_collision())
		
		#emit_signal("finished", "idle")#change this to bounce

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
	return owner.get_last_slide_collision()
	#return owner.get_slide_collision(0)
	
func exit():
	owner.knockback_direction = owner.knockback_direction *-1
	owner.set_collision_layer_bit(0,true)
	owner.set_collision_mask_bit(0,true)

#only stops when you hit the wall
#func _on_animation_finished(anim_name):
	#emit_signal("finished", "idle")
