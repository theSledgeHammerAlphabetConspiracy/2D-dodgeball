# Collection of important methods to handle direction and animation
extends "../state.gd"

func handle_input(event):
	#if ctrl == 1 and hasball == true else "catch"
	if event.is_action_pressed("B"+owner.player_team):
		#emit_signal("finished", "throw")
		emit_signal("finished", "catch")
	#this whole thing needs to be moved to the collision system
	if event.is_action_pressed("simulate_damage"+owner.player_team):
		#change the hitstop stun_type here
		#this is suppose to be in the get hit state and set in the VBox
		owner.take_damage(self, 10,Vector2(-owner.get_node("BodyPivot").get_scale().x,0),200)
	elif event.is_action_pressed("C"+owner.player_team):
		#change the hitstop stun_type here
		#this is suppose to be in the get hit state and set in the VBox
		#attacker, damage, kb_D, kb_A= 1200, type=0, effect=null)
		owner.take_damage(self, 10,Vector2(-owner.get_node("BodyPivot").get_scale().x,0),2000,6)
#
func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right"+owner.player_team)) - int(Input.is_action_pressed("move_left"+owner.player_team))
	input_direction.y = int(Input.is_action_pressed("move_down"+owner.player_team)) - int(Input.is_action_pressed("move_up"+owner.player_team))
	return input_direction

func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
	if not direction.x in [-1, 1]:
		return
	owner.get_node("BodyPivot").set_scale(Vector2(direction.x, 1))
	owner.get_node("APivot").set_scale(Vector2(direction.x, 1))
