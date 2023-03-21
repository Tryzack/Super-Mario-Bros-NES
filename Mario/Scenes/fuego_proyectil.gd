extends CharacterBody2D
var existe = true
var gravity = Gamehandler.gravity
@export var speed = 200
var direction = 1

func _process(delta):
	if(!is_on_floor()):
		velocity.y += delta * gravity
	if(is_on_floor()):
		velocity.y = -125
	if(is_on_wall()):
		queue_free()
		existe = false
	velocity.x = speed * direction
	move_and_slide()

func _on_area_2d_body_entered(body):
	if(body.is_in_group("enemigos")):
		body.muerte()
		queue_free()
