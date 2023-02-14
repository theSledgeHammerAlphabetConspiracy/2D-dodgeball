extends Area2D


var speed : float = 10.0
#var speed_range = range(10,30)
var thrower

var state = 2
var target: Vector2 = Vector2(0,0)
var dir:= Vector2(0,0)
var Zvel:= 0

func _ready():
	pass
	#speed = rand_range(10,30)
	#print(thrower.get_name())

func _physics_process(delta):
	if state == 0:#throw
		move_local_x(speed*-1)
	if state == 1:#bounce to target
		dir = Vector2(target - get_global_position()).normalized()
		move_local_x(dir.x)
		move_local_y(dir.y)
		$ball.position.y += Zvel*delta
		if $ball.position.y < 0:
			Zvel += 1
		else:
			Zvel = (Zvel/1.2) *-1
			state = 2
	if state == 2:#idle
		#needs an enter block
		$ball.position.y += Zvel*delta
		if $ball.position.y < 0:
			Zvel += 1
		else:
			#Zvel = 0
			Zvel = (Zvel/1.5) *-1
		clamp($ball.position.y,-10000,0)
		#print('done')
		
func _on_Node2D_body_entered(body):
	if state == 0:
		if body == thrower:
			pass
		else:
			body._collision(self)
	elif state == 2:
		pass
		#pickedup state 3

func _bounce(from_pos):
	target = from_pos+ Vector2(rand_range(20*speed,1000*speed),rand_range(-1000*speed,1000*speed))
	#ball.target = get_global_position()+Vector2(3000,3000)
	Zvel = speed * rand_range(1,3) * -1
	state = 1

