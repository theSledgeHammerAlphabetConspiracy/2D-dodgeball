extends Area2D


var speed : float = 10.0
#var speed_range = range(10,30)
var thrower #maybe removeable
var team: String = ""

var throwDir: Vector2 = Vector2(0,0)

var state = 2
var target: Vector2 = Vector2(0,0)
var dir:= Vector2(0,0)
var Zvel:= 0

var grabbed_by = null

func _ready():
	pass
	#speed = rand_range(10,30)
	#print(thrower.get_name())

func _physics_process(delta):
	if state == 0:#throw
		move_local_x(speed*throwDir.x)
		move_local_y(speed*throwDir.y)
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
	#print(body)
	if body.is_in_group("wall"):
		_bounce(body.get_global_position())
	else:
		if state == 0:
			if body == thrower or body.player_team == team:
				#print("G")
				pass
			else:
				body._collision(self)
		elif state == 2:
			body._getball()
			queue_free()
		#grabbed_by = body
		#state = 3

func _bounce(from_pos):
	var bouncedir = Vector2(0,0)
	#print(throwDir.x)
	if throwDir.x > 0.0:
		bouncedir.x = -1
	elif throwDir.x < 0.0:
		bouncedir.x = 1
	if throwDir.y > 0.0:
		bouncedir.y = -1
	elif throwDir.y < 0.0:
		bouncedir.y = 1
	#print(bouncedir)
	#target = from_pos + (Vector2(bouncedir,1)*Vector2(rand_range(20*speed,1000*speed),rand_range(-1000*speed,1000*speed)))
	target = from_pos + bouncedir*Vector2(rand_range(20*speed,1000*speed),rand_range(speed,1000*speed))
	#ball.target = get_global_position()+Vector2(3000,3000)
	Zvel = speed * rand_range(1,3) * -1
	state = 1

