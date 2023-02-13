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

export var vertical_speed = 0.0
var height = 0.0


var h_speed
var h_dir
var v_height


func _init():
	cancelable = true
	physics_type = 1#air physics for gethit

func initialize(speed, velocity, pos):#this is called in the state machine and that is wrong it probably should be called on 
	h_speed = speed
	max_horizontal_speed = speed if speed > 0.0 else BASE_MAX_HORIZONTAL_SPEED
	h_dir = velocity
	height = pos *-1


func enter():
	owner.get_node("AnimationPlayer").play("wallbounce")
	
func update(delta):
	var collision_info = move_horizontally(owner.knockback_amount, owner.knockback_direction)
	animate_jump_height(delta)
	if height <= 0.0:
		##################################################this needs to go to the knockdown state
		emit_signal("finished", "knockdown")
		
func move_horizontally(amount, direction):

	owner.move_and_slide((Vector2(1,.5)*direction)*amount)

func animate_jump_height(delta):
	vertical_speed -= GRAVITY * delta
	height += vertical_speed * delta
	height = max(0.0,height)

	owner.get_node("BodyPivot").position.y = -height
