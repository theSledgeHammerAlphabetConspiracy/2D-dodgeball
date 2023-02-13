extends "res://player_v2/state_machine.gd"

func _ready():
	states_map = {
		"idle": $Idle,
		#"move": $Move,
		#"jump": $Jump,
		#"jumpstart":$JumpStart,
		#"jumpland":$JumpLand,
		"hitstop": $Hitstop,#old stagger
		#"attack": $Attack,
		"hitstunGr":$HitstunGr,
		"hitstunA":$HitstunA,
		"blowback":$Blowback,
		"wallbounce":$Wallbounce
		
		#"knockdown":$Knockdown,
		
		#"string1":$String1,
		#"string2":$String2,
		#"string3":$String3,
		#"special":$Special
	}

func _change_state(state_name):
	"""
	The base state_machine interface this node extends does most of the work
	"""
	if not _active:
		return
	if state_name in ["hitstop", "jump", "attack"]:
		states_stack.push_front(states_map[state_name])
	if state_name == "jump" and current_state == $Move:
		#print($Move.velocity)
		$Jump.initialize($Move.speed, $Move.velocity)
	#if state_name == "hitstunA" and current_state == $Jump:
		#$HitstunA.initialize(owner.knockback_amount, owner.knockback_direction, owner.get_node("BodyPivot").position.y)
	._change_state(state_name)
	owner.get_node("StateNameDisplayer").set_text(state_name)

func _input(event):
	"""
	Here we only handle input that can interrupt states, attacking in this case
	otherwise we let the state node handle it
	"""
	if event.is_action_pressed("attack"):
		if current_state == $Attack:### probably needs to be changed to ctrl variable as is u can attack out of stagger
			return
		_change_state("attack")
		return
	current_state.handle_input(event)


func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)
