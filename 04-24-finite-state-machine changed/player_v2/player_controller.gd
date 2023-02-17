extends KinematicBody2D

signal direction_changed(new_direction)#connected to the weapon pivot script

export var cValue: int = 0

export var player_team: String = "1"

var look_direction = Vector2(1, 0) setget set_look_direction

var knockback_direction := Vector2()
export var knockback_amount : float = 0.0
var knockback_type : int = 0

onready var attack_KB_dir : Vector2 = Vector2($BodyPivot.get_scale().x,0)
onready var attack_KB_amount: float = 200
onready var attack_KB_type: int = 0
onready var attack_DMG_amount: int = 0

var string_series: int = 0

var height: float = 0.0
var hasball: bool = false

func _ready():
	add_to_group("player"+player_team)
	#print(get_tree().get_nodes_in_group('player1'))

func take_damage(attacker, damage, kb_D, kb_A= 1200, type=0, effect=null):
	#print("take damage in player controller is ran")
	if attacker.is_in_group("player"+player_team):
		return
	knockback_amount = kb_A
	knockback_direction = kb_D
	knockback_type = type
	#$States/Hitstop.knockback_direction = knockback
	#$States/Hitstop.knockback_direction = (attacker.global_position - global_position).normalized()#this might be nice for DI
	$Health.take_damage(damage, effect)
	$StateMachine._change_state("hitstop")
	
func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionPolygon2D.disabled = value

func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)
	
func _on_ABox_area_entered(area):
	$AnimationPlayer.stop(false)
	$Timer.start()
	area.owner.take_damage(self, attack_DMG_amount, attack_KB_dir, attack_KB_amount, attack_KB_type)

func animate_jump_height(delta,vertical_speed):
	height += vertical_speed * delta
	height = max(0.0,height)

	get_node("BodyPivot").position.y = -height
	
func _on_Timer_timeout():#hitstop timer
	#print("hitstop over")
	$AnimationPlayer.play()
	
func _getball():
	hasball = true
	$BodyPivot/body/hasball.show()
	
func _collision(ball):
	#print(cValue)
	#var stupid = Vector2(get_global_position()-ball.get_global_position()).normalized().angle()
	#print(rad2deg(stupid))
	if cValue == 0:
		$StateMachine._change_state("hitstop")
		ball._bounce(get_global_position())
	elif cValue == 1:
		ball.queue_free()
	elif cValue == 2:
		ball._bounce(get_global_position())
	
func _on_catchcooldown_timeout():
	pass # Replace with function body.
	
