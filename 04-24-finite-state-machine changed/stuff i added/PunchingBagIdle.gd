extends "res://player/states/state.gd"

func enter():
	owner.get_node("AnimationPlayer").play("idle")
