extends "res://player/states/state.gd"


var stun_type = 0#this will get passed in from both the physics_type the character had before 
#the hit (1=air or 0=ground) and will be compared to the hit type the attack forces (dont have this 
#started yet 1/24)

func _init():
	cancelable = true

func enter():
	#print(get_parent().states_stack)
	if owner.knockback_type == 0:
		stun_type = get_parent().states_stack[1].physics_type#this is if the ABox doesnt have an overriding
	elif owner.knockback_type == 6:#blowback
		stun_type = 6
	owner.get_node("AnimationPlayer").play("hitstop")

func _on_animation_finished(anim_name):
##	print("H")
##	#emit_signal("finished", "hitstunA")
	if stun_type == 0:
		emit_signal("finished", "hitstunGr")
	elif stun_type ==6:
		#print("in")
		emit_signal("finished", "blowback")
#####add this back in when the states are added in 1/31
	elif stun_type == 1:
		get_parent().get_node('HitstunA').initialize(owner.knockback_amount, owner.knockback_direction, owner.get_node("BodyPivot").position.y)
		emit_signal("finished", "hitstunA")

func exit():
	stun_type = 0



