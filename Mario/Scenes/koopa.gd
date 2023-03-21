extends CharacterBody2D
class_name koopa

@export var speed : float = 50 #asignar velocidad
var gravity = Gamehandler.gravity #asignar gravedad
var enabled_movement = true #permitir movimiento
var direction = -1 #direccion por defecto
var direction_change = false #cambiar de direccion
var vivo : bool = true
var rodando : bool = true
var caparazon: bool = false

func _ready():
	get_node("AnimationPlayer").play("caminando")

func _physics_process(delta):
	
	if(enabled_movement):
		if not is_on_floor():
			velocity.y += gravity * delta
		if(is_on_wall()): #si se encuentra una pared
			direction_change = true # permitir cambio de direccion
		if(direction==1):
			get_node("Sprite2D").flip_h = true
		elif(direction==-1):
			get_node("Sprite2D").flip_h = false
		if((not (get_node("RayCast2D").is_colliding()) or not (get_node("RayCast2D2").is_colliding())) and not caparazon):
			direction_change = true
		if(direction_change == true): #aplicar cambio de direccion
			if(direction == 1):
				direction = -1
			elif(direction == -1):
				direction = 1
		direction_change = false #desactivar permiso de cambio de direccion
		velocity.x = speed * direction #calcular la velocidad en X
		move_and_slide()
		
	if(rodando and caparazon):
		speed = 150
	elif(not rodando and caparazon):
		speed = 0
		
func recibir_golpe():
	if(vivo):
		if(not caparazon):
			get_node("sonidos/enemigo muerto").play()
			get_node("Label").visible = true
			Gamehandler.agregar_puntuacion(250)
			Gamehandler.update_ui()
			get_node("Timer").start()
		speed = 0
		get_node("AnimationPlayer").stop()
		get_node("AnimationPlayer").play("convertir en tortuga")
		get_node("ColisionVivo").set_deferred("disabled", true)
		get_node("ColisionMuerto").set_deferred("disabled", false)
		get_node("golpe_derecha/CollisionShape2D").set_deferred("disabled", false)
		get_node("golpe_izquierda/CollisionShape2D").set_deferred("disabled", false)
	if(caparazon):
		get_node("sonidos/patear").play()
	caparazon = true
	if(rodando):
		rodando = false
	elif(not rodando):
		rodando = true

func muerte():
	get_node("sonidos/patear").play()
	get_node("Label2").visible = true
	Gamehandler.agregar_puntuacion(500)
	Gamehandler.update_ui()
	vivo = false
	get_node("ColisionVivo").set_deferred("disabled", true)
	get_node("ColisionMuerto").set_deferred("disabled", true)
	get_node("golpe_derecha/CollisionShape2D").set_deferred("disabled", true)
	get_node("golpe_izquierda/CollisionShape2D").set_deferred("disabled", true)
	get_node("AnimationPlayer").play("muerte")

func _on_golpe_izquierda_body_entered(body):
	
	if(body.is_in_group("mario") and not rodando):
		direction = 1
		rodando = true
		get_node("sonidos/patear").play()
		
	elif(body.is_in_group("mario") and rodando and body.velocity.x > 0):
		if(not body.inmunity):
			body.destransformar()
			
	elif(body.is_in_group("enemigos") and body.vivo and rodando):
		body.muerte()

func _on_golpe_derecha_body_entered(body):
	if(body.is_in_group("mario") and not rodando):
		direction = -1
		rodando = true
		get_node("sonidos/patear").play()
		
	elif(body.is_in_group("mario") and rodando and body.velocity.x < 0):
		if (not body.inmunity):
			body.destransformar()
			
	elif(body.is_in_group("enemigos") and body.vivo and rodando):
		body.muerte()

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "muerte"):
		queue_free()

func _on_golpe_medio_body_entered(body):
	if(body.is_in_group("mario") and rodando == true):
		if(not body.inmunity):
			body.destransformar()

func _on_area_2d_body_entered(body):
	if(body.is_in_group("mario")):
		pass#enabled_movement = true


func _on_timer_timeout():
	get_node("Label").visible = false
