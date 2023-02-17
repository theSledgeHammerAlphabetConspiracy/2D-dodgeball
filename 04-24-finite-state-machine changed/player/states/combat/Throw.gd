extends "../motion/on_ground/on_ground.gd"

export(float) var MAX_WALK_SPEED = 450
export(float) var MAX_RUN_SPEED = 700

export var chargeable: bool = false
export var stringadd:bool = true
#var series: int = 0 #moved to player string_series
export var advance: bool = false
var locked_direction:= Vector2()
export var locked_speed:float=0.0
var chargespeed:float=0.0



var ball = preload("res://stuff i added/dodgeball only/ball.tscn")
var target: Vector2 = Vector2(0,0)

# get rid of the transition to idle after the shoot after testing the catch
var input_direction 
func enter():
	advance = false
	chargeable=false#this fixes the animation bug
	#play move
	speed = 0.0
	velocity = Vector2()
	owner.string_series = 0 #end of series
	chargespeed = 0.0
#
#	owner.attack_KB_dir = Vector2(owner.get_node("BodyPivot").get_scale().x,0)
#	owner.attack_KB_amount = 2000
#	owner.attack_KB_type = 6#blowback
	
	#this allows for the second attack in the string to attack behind the player.. this might be bad
	input_direction = get_input_direction()
	update_look_direction(input_direction)
	#locked_direction = Vector2(owner.get_node("BodyPivot").get_scale().x,0)
	#update_look_direction(input_direction)
	#update_look_direction(locked_direction)
	owner.get_node("AnimationPlayer").play("throw")

func _shoot():
	var shot = ball.instance()
	shot.global_position = owner.get_node('BodyPivot/handspivot/ballpos').global_position
	shot.team = owner.player_team
	shot.throwDir = target
	#shot.throwDir = Vector2(1,0)
	shot.thrower = self
	shot.speed = rand_range(10,30)
	shot.state = 0
	#print(target)
	#$Label.set_text($Label.get_text()+"\n"+str(shot.speed))
	owner.hasball = false
	get_parent().add_child(shot)

func _aim():
	input_direction = get_input_direction()
	update_look_direction(input_direction)
	if owner.get_node('BodyPivot/handspivot/targetsight').get_overlapping_bodies().size() >= 1:
		target = Vector2(owner.get_node('BodyPivot/handspivot/targetsight').get_overlapping_bodies()[0].get_global_position()-owner.get_global_position()).normalized()
		#print(owner.get_node('BodyPivot/handspivot/targetsight').get_overlapping_bodies()[0])
	else:
		target = owner.look_direction
	
	#print(owner.look_direction)

func handle_input(event):
	if event.is_action_pressed("special"+owner.player_team):
		emit_signal("finished","special")
	#return .handle_input(event)
#
func update(delta):
	#print(owner.look_direction)
	#this is the basic low kick isnt charageable
	if Input.is_action_pressed("jump"+owner.player_team) and chargeable == true:
		owner.get_node("AnimationPlayer").stop(false)
		chargespeed +=10.0
		_aim()
	else:
		if chargespeed >= 600:
			chargespeed = 600
		owner.get_node("AnimationPlayer").play()
		
#	maybe running throws will have an advance
#	if advance == true:
#		#below is in the special attack but not in the thrid hit of the the string so the up down input
#		#can be used for different blowbacks
#		#locked_direction.y = get_input_direction().y
#		var collision_info = move(locked_speed+chargespeed, locked_direction)
#		if not collision_info:
#			return

func move(speed, direction):
	#velocity = direction.normalized() * speed
	velocity = (direction.normalized()*Vector2(1,.5)) * speed
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)
	
func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")
