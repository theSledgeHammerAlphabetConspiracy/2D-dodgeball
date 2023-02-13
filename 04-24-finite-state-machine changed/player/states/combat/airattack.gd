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

func initialize(speed, dir, pos):#this is called in the state machine and that is wrong it probably should be called on 
	h_speed = speed
	#max_horizontal_speed = speed if speed > 0.0 else BASE_MAX_HORIZONTAL_SPEED
	h_dir = dir
	height = pos *-1
	#print(h_speed, h_dir)

func enter():
	vertical_speed = 200.0
	owner.get_node("AnimationPlayer").play("airattack")
	#print(height)
	
func update(delta):
	# the jump is already normalized this is gettin stupid and hacky
	var collision_info = move_horizontally(h_speed)

	animate_jump_height(delta)
	if height <= 0.0:
		emit_signal("finished", "jumpland")
		
func move_horizontally(amount):#this is different cause the jump already passes in a normalized amount
	#direction = direction * Vector2(1,.5)
	owner.move_and_slide(amount)

func animate_jump_height(delta):
	vertical_speed -= GRAVITY * delta
	height += vertical_speed * delta
	height = max(0.0,height)

	owner.get_node("BodyPivot").position.y = -height
