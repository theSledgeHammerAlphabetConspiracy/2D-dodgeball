extends "res://player/states/state.gd"

var velocity

func enter():
	owner.set_collision_layer_bit(0,false)
	owner.set_collision_mask_bit(0,false)
	owner.get_node("AnimationPlayer").play("blowback")
	
func update(delta):
	var collision_info = move(owner.knockback_amount, owner.knockback_direction)
	if not collision_info:
		return
		
	if collision_info.collider.is_in_group("wall"):
		###HOLY SIT THE LEVEL OF NONSENSE see punching bag commented out stuff
		if collision_info.collider.get_name() == "Vector2"+str(owner.knockback_direction):
			emit_signal("finished", "wallbounce")#change this to bounce

func move(speed, direction):
	#velocity = direction.normalized() * speed
	velocity = (direction.normalized()*Vector2(1,.5)) * speed
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_last_slide_collision()
	
func exit():
	owner.knockback_direction = owner.knockback_direction *-1
	owner.set_collision_layer_bit(0,true)
	owner.set_collision_mask_bit(0,true)
