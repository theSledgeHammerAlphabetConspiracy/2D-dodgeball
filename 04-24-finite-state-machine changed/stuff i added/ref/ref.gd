extends Sprite

var ball = preload("res://stuff i added/dodgeball only/ball.tscn")
var target: Vector2 = Vector2(0,0)
var player_team = '0'

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if Input.is_action_just_pressed("P1"):
		#print(get_node('/root/Demo/YSort/PlayerV2').get_name())
		_shoot_at_active()
	
func _shoot_at_active():
	var shot = ball.instance()
	shot.global_position = get_node('ballpos').global_position
	shot.team = player_team
	#target first - self 
	shot.throwDir = Vector2(get_node('/root/Demo/YSort/PlayerV2').get_global_position() - get_global_position()).normalized()
	#shot.throwDir = Vector2(1,0)
	shot.thrower = self
	shot.speed = 10#rand_range(10,30)
	shot.state = 0
	#owner.hasball = false
	#print(shot.throwDir)
	get_parent().add_child(shot)
