extends "../motion.gd"

var speed = 0.0
var velocity = Vector2()



func handle_input(event):
	if event.is_action_pressed("jump"+owner.player_team) and owner.get_node("catchcooldown").is_stopped():
		#owner.hasball == false:
		emit_signal("finished", "catch")
		#owner.hasball == true:
		#throw
		
		
		
#		#emit_signal("finished", "jump")
#		emit_signal("finished", "jumpstart")
#	if event.is_action_pressed("stringA"+owner.player_team):
#		emit_signal("finished","string1")
#	if event.is_action_pressed("special"+owner.player_team):
#		emit_signal("finished","special")
	return .handle_input(event)
