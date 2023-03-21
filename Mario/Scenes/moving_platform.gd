extends CharacterBody2D
@export var direction : int = 1 #1 = abajo / -1 = arriba
@export var speed : int = 50

func _process(_delta):
	velocity.y = speed * direction
	move_and_slide()

func warp_to(pos):
	global_position.y = pos
