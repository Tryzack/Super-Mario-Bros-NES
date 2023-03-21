extends CharacterBody2D

@export var speed : float = 50 #asignar velocidad
var gravity = Gamehandler.gravity #asignar gravedad
var enabled_movement : bool = false #permitir movimiento
var direction = -1 #direccion por defecto
var direction_change = false #cambiar de direccion
var vivo : bool = true
func _ready():
	get_node("AnimationPlayer").play("caminando")

func _physics_process(delta):
	
	if(enabled_movement):
		if not is_on_floor():
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
		move_and_slide()

func recibir_golpe():
	muerte()

func muerte():
	get_node("enemigo muerto").play()
	get_node("Label").visible = true
	Gamehandler.agregar_puntuacion(250)
	Gamehandler.update_ui()
	vivo = false
	enabled_movement = false
	get_node("CollisionShape2D").set_deferred("disabled", true)
	get_node("AnimationPlayer").play("muerte")

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "muerte"):
		queue_free()

func _on_area_2d_body_entered(body):
	if(body.is_in_group("mario")):
		enabled_movement = true
