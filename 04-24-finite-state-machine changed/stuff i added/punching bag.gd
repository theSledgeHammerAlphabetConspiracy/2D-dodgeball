extends KinematicBody2D

export var player_team: String = "2"

#not sure if i need this but w/e
var look_direction = Vector2(1, 0) setget set_look_direction


var knockback_direction := Vector2()
export var knockback_amount : float = 0.0
var knockback_type : int = 0

onready var attack_KB_dir : Vector2 = Vector2($BodyPivot.get_scale().x,0)
onready var attack_KB_amount: float = 200
onready var attack_KB_type: int = 0
onready var attack_DMG_amount: int = 0

func _ready():
	add_to_group("player"+player_team)
	#print(get_tree().get_nodes_in_group('player1'))

func take_damage(attacker, damage, kb_D, kb_A= 1200, type=0, effect=null):
	if attacker.is_in_group("player"+player_team):
		return
	knockback_amount = kb_A
	knockback_direction = kb_D
	knockback_type = type
	#$States/Hitstop.knockback_direction = knockback
	#$States/Hitstop.knockback_direction = (attacker.global_position - global_position).normalized()#this might be nice for DI
	#$Health.take_damage(damage, effect)#punching bags might have health later
	$StateMachine._change_state("hitstop")

func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionPolygon2D.disabled = value

func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)
