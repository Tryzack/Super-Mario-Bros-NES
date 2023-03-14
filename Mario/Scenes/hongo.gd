extends CharacterBody2D
@export var tipo : int # 0 = rojo / 1 = verde
@export var speed : float = 50 #asignar velocidad
var gravity = Gamehandler.gravity #asignar gravedad
var movement_enabled = false #permitir movimiento
var direction = 1 #direccion por defecto
var direction_change = false #cambiar de direccion

func _ready():
		get_node("AnimationPlayer").play("spawn") #animacion al spawnear
		
func _physics_process(delta):
	if(movement_enabled == true): #si el hongo se puede mover
		if not is_on_floor(): #si esta en el aire aplicar gravedad
			velocity.y += gravity * delta
		if(is_on_wall()): #si se encuentra una pared
			direction_change = true # permitir cambio de direccion
		if(direction_change == true): #aplicar cambio de direccion
			if(direction == 1):
				direction = -1
			else:
				direction = 1
		direction_change = false #desactivar permiso de cambio de direccion
		velocity.x = speed * direction #calcular la velocidad en X
		move_and_slide() #mover cuerpo
		
func _on_animation_player_animation_finished(_anim_name):
	movement_enabled = true #activar movimiento despues de spawnear
