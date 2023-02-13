extends Node2D

var bullet = preload("Bullet.tscn")

func _input(event):
	if event.is_action_pressed("fire"):
		fire(owner.look_direction)

func fire(direction): ### this is basically an assist call out of hte box can be used in stagger and attack
	if not $CooldownTimer.is_stopped():
		return

	$CooldownTimer.start()
	var new_bullet = bullet.instance()
	new_bullet.set_global_position(self.get_global_position())
	new_bullet.direction = direction
	add_child(new_bullet)
