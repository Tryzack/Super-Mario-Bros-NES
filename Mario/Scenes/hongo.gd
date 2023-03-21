extends CharacterBody2D
@export var tipo : int # 0 = rojo / 1 = verde
@export var speed : float = 50 #asignar velocidad
var gravity = Gamehandler.gravity #asignar gravedad
var enabled_movement : bool = false #permitir movimiento
var direction = 1 #direccion por defecto
var direction_change = false #cambiar de direccion

func _ready():
		if(tipo == 0):
			get_node("AnimationPlayer").play("spawn_rojo") #animacion al spawnear
		if(tipo == 1):
			get_node("AnimationPlayer").play("spawn_verde")
		if(tipo == 2):
			get_node("AnimationPlayer").play("spawn")
			
func _physics_process(delta):
	if(enabled_movement == true): #si el hongo se puede mover
		if not is_on_floor(): #si esta en el aire aplicar gravedad
			velocity.y += gravity * delta
		if(tipo == 0 or tipo == 1):
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
		
func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "spawn"):
		get_node("AnimationPlayer").play("flor_idle")
	enabled_movement = true #activar movimiento despues de spawnear
