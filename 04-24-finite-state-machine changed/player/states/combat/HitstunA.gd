extends "../motion/motion.gd"


export(float) var BASE_MAX_HORIZONTAL_SPEED = 400.0

export(float) var AIR_ACCELERATION = 1000.0
export(float) var AIR_DECCELERATION = 2000.0
export(float) var AIR_STEERING_POWER = 50.0 # is CV jumps

export(float) var JUMP_HEIGHT = 120.0
export(float) var JUMP_DURATION = 0.8

export(float) var GRAVITY = 1600.0

var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
var horizontal_speed = 0.0
var horizontal_velocity = Vector2()

var vertical_speed = 0.0
var height = 0.0


var h_speed
var h_dir
var v_height


func _init():
	cancelable = true
	physics_type = 1#air physics for gethit



#####as of feb this is being called in the hitstop 
func initialize(speed, velocity, pos):#this is called in the state machine and that is wrong it probably should be called on 
	
	
	
	#exiting the jump start animation/state
	#print(owner.get_node("BodyPivot").position.y)
	#horizontal_speed = speed
	h_speed = speed
	max_horizontal_speed = speed if speed > 0.0 else BASE_MAX_HORIZONTAL_SPEED
	#enter_velocity = velocity
	h_dir = velocity
	#print("p"+str(pos))
	height = pos *-1
	#print("h"+str(height))
	#owner.get_node("BodyPivot").position.y = pos
	#print(owner.get_node("BodyPivot").position.y)

func enter():
	#var input_direction = get_input_direction()
	#update_look_direction(input_direction)
	#height = owner.get_node("BodyPivot").position.y
	#horizontal_velocity = enter_velocity if input_direction else Vector2()
	vertical_speed = 200.0
	#print(owner.get_node("BodyPivot").position.y)
	owner.get_node("AnimationPlayer").play("hitstunA")
	#print(height)
	
func update(delta):
	var collision_info = move_horizontally(owner.knockback_amount, owner.knockback_direction)
	
	#u cant change facing while hit
	#var input_direction = get_input_direction()
	#update_look_direction(input_direction)

	#move_horizontally(delta, input_direction)
	animate_jump_height(delta)
	if height <= 0.0:
		##################################################this needs to go to the knockdown state
		emit_signal("finished", "knockdown")
		
func move_horizontally(amount, direction):
#	if direction:
#		horizontal_speed += AIR_ACCELERATION * delta
#	else:
#		horizontal_speed -= AIR_DECCELERATION * delta
	
	#horizontal_speed = clamp(horizontal_speed, 0, max_horizontal_speed)

	#var target_velocity = horizontal_speed * direction.normalized()
	#var steering_velocity = (target_velocity - horizontal_velocity).normalized() * AIR_STEERING_POWER
	#horizontal_velocity += steering_velocity
	direction = direction * Vector2(1,.5)
	owner.move_and_slide(direction*amount)

func animate_jump_height(delta):
	#print(height)
	#height -= .01
	# i have no idea why this works but it does it worked because the previous state was air and it was defaulting to it
	#pass
	vertical_speed -= GRAVITY * delta
	height += vertical_speed * delta
	height = max(0.0,height)

	owner.get_node("BodyPivot").position.y = -height
