extends CharacterBody2D
@export var tipo : int # 0 = rojo / 1 = verde
@export var speed : float = 50
var gravity = Gamehandler.gravity
var movement_enabled = false
var direction = 1
var direction_change = false
func _ready():
		get_node("AnimationPlayer").play("spawn")
		
func _physics_process(delta):
	if(movement_enabled == true):
		if not is_on_floor():
			velocity.y += gravity * delta
		if(is_on_wall()):
			direction_change = true
		if(direction_change == true):
			if(direction == 1):
				direction = -1
			else:
				direction = 1
		direction_change = false
		velocity.x = speed * direction
		move_and_slide()
		
func _on_animation_player_animation_finished(_anim_name):
	movement_enabled = true
