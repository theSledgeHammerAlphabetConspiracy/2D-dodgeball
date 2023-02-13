extends "../motion/on_ground/on_ground.gd"

#modified in the animation
export var get_up_roll_speed = 0
onready var input_direction = get_input_direction()

func enter():
	owner.get_node("AnimationPlayer").play("knockdown")
	input_direction = get_input_direction()
	input_direction += Vector2(owner.knockback_direction.x,input_direction.y)
	#input_direction = Vector2(-owner.get_node("BodyPivot").get_scale().x,input_direction.y)
	#input_direction -=  Vector2(owner.get_node("BodyPivot").get_scale().x,0)
func handle_input(event):
	pass
#	return .handle_input(event)

func update(_delta):
	#print(owner.knockback_amount)
	
	#this will work if you want lots of teching
	#var input_direction = get_input_direction()
	#if input_direction:
		#("finished", "move")
	##var collision_info = move(get_up_roll_speed, input_direction)
	var collision_info = move(owner.knockback_amount, input_direction)
	if not collision_info:
		return
	#if speed == MAX_RUN_SPEED and collision_info.collider.is_in_group("environment"):
		#return null

func move(speed, direction):
	velocity = direction.normalized() * speed
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)

func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")
