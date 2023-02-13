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

func enter():
	advance = false
	#play move
	speed = 0.0
	velocity = Vector2()
	owner.string_series = 0 #end of series
	chargespeed = 0.0
	
	owner.attack_KB_dir = Vector2(owner.get_node("BodyPivot").get_scale().x,0)
	owner.attack_KB_amount = 2000
	owner.attack_KB_type = 6#blowback
	
	#this allows for the second attack in the string to attack behind the player.. this might be bad
	#var input_direction = get_input_direction()
	#update_look_direction(input_direction)
	locked_direction = Vector2(owner.get_node("BodyPivot").get_scale().x,0)
	#update_look_direction(input_direction)
	update_look_direction(locked_direction)
	owner.get_node("AnimationPlayer").play("overhead")

func handle_input(event):
	if event.is_action_pressed("special"+owner.player_team):
		emit_signal("finished","special")
	#return .handle_input(event)
#
func update(delta):
	#this is the basic low kick isnt charageable
	if Input.is_action_pressed("stringA"+owner.player_team) and chargeable == true:
		owner.get_node("AnimationPlayer").stop(false)
		chargespeed +=10.0
	else:
		if chargespeed >= 600:
			chargespeed = 600
		owner.get_node("AnimationPlayer").play()
		
	#end of string
#	if stringadd == true and Input.is_action_just_pressed("stringA"+owner.player_team):
#		series += 1

	var blowback_dir = get_input_direction()
	match blowback_dir:
		Vector2(0,1):
			owner.attack_KB_dir = Vector2(0,1)
		Vector2(0,-1):
			owner.attack_KB_dir = Vector2(0,-1)
		_:
			owner.attack_KB_dir = Vector2(owner.get_node("BodyPivot").get_scale().x,0)
		
#	if blowback_dir.y == 1:
#		owner.attack_KB_dir = Vector2(0,1)
#	elif blowback_dir.y == -1:
#		owner.attack_KB_dir = Vector2(0,-1)
#	elif blowback_dir.x == owner.get_node("BodyPivot").get_scale().x:
#		owner.attack_KB_dir = Vector2(owner.get_node("BodyPivot").get_scale().x,0)
#	elif blowback_dir.x == 0:
#		owner.attack_KB_dir = Vector2(owner.get_node("BodyPivot").get_scale().x,0)
	##########not sure what to do if you press backwards cause i think you might switch directions
		
		

	if advance == true:
		#below is in the special attack but not in the thrid hit of the the string so the up down input
		#can be used for different blowbacks
		#locked_direction.y = get_input_direction().y
		var collision_info = move(locked_speed+chargespeed, locked_direction)
		if not collision_info:
			return

func move(speed, direction):
	#velocity = direction.normalized() * speed
	velocity = (direction.normalized()*Vector2(1,.5)) * speed
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)


#no cancel check until specials
#func cancel_check():
##	if series != 1:
##		pass
##	el
#	if series >= 1:
#		emit_signal("finished", "string3")
#

func _on_animation_finished(anim_name):
	emit_signal("finished", "idle")
