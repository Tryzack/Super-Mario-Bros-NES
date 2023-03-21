extends CharacterBody2D

@export var SPEED : float = 125 #velocidad
@export var JUMP_VELOCITY : float = -370.0 #fuerza del salto
@export var mario_p : Texture
@export var mario_g : Texture	#texturas de mario en sus distintas formas
@export var mario_f : Texture
@onready var colision = get_node("colision_p")		#asignar colisiones a mario
@onready var raycast_cabeza = get_node("colision_p/RayCastCabeza")	#asignar colisiones a mario
@onready var raycast_pisar = get_node("colision_p/RayCastPisar")	#asignar colisiones a mario
@onready var raycast_pisar2 = get_node("colision_p/RayCastPisar2")	#asignar colisiones a mario
@onready var raycast_pisar3 = get_node("colision_p/RayCastPisar3")	#asignar colisiones a mario
signal muerte #senal cuando mario muere
signal warp
signal warped
signal parar_musica
var use_sound = true
var win
var is_pressing_s : bool
var is_pressing_a : bool
var is_pressing_d : bool
var is_pressing_w : bool
var trans_p = load("res://Scenes/colisiones_mario_p.tscn")	#cargar colisiones de los distintos tamanos de mario
var trans_g = load("res://Scenes/colisiones_mario_g.tscn")	#  "" 
var gravity = Gamehandler.gravity #asignar gravedad (valor general para los cuerpos)
var forma : int = 0	# 0 = pequeno / 1 = grande / 2 = fuego
var estado : int = 1	# 0 = muerto / 1 = vivo
var agachado : bool = false
var colision_hecha : bool = false #revisar si se realizo una colision
var enabled_movement : bool #permitir movimiento
var last_direction
var inmunity = false
var vivo: bool = true

func _ready(): #parametros iniciales
	forma = 0
	enabled_movement = true #activar movimientos
	get_node("colision_g").set_deferred("disabled", true) #desactivar colisiones M_g
	get_node("colision_g").desactivar_colisiones() #desactivar colisiones M_g
	get_node("colision_p").activar_colisiones() #activar colisiones M_p
	
func _physics_process(delta): #movimiento
	
	if(enabled_movement):
		
		if not is_on_floor(): #aplicar gravedad
			if(agachado):
				agachado = false
			velocity.y += gravity * delta
			get_node("AnimationPlayer").play("salto") #animar salto
			
		if(Input.is_action_just_pressed("tecla_s") and is_on_floor() and forma > 0):
			velocity.x = 0
			get_node("AnimationPlayer").play("agachado")
			agachado = true
			#set_colcast()
		elif(Input.is_action_just_released("tecla_s") and is_on_floor() and forma > 0):
			get_node("AnimationPlayer").play("idle")
			agachado = false
			#set_colcast()
		
		if(Input.is_action_pressed("tecla_s")):
			is_pressing_s = true
		elif(not Input.is_action_pressed("tecla_s")):
			is_pressing_s = false
		if(Input.is_action_pressed("tecla_w")):
			is_pressing_w = true
		elif(not Input.is_action_pressed("tecla_w")):
			is_pressing_w = false
		if(Input.is_action_pressed("tecla_a")):
			is_pressing_a = true
		elif(not Input.is_action_pressed("tecla_a")):
			is_pressing_a = false
		if(Input.is_action_pressed("tecla_d")):
			is_pressing_d = true
		elif(not Input.is_action_pressed("tecla_d")):
			is_pressing_d = false
		
		if(!agachado):
				
			if Input.is_action_just_pressed("tecla_w") and is_on_floor():
				velocity.y = JUMP_VELOCITY #saltar cuando "W" es presionada
				get_node("sonidos/saltar").play()
			
			var direction = Input.get_axis("tecla_a", "tecla_d") #obtener direccion con "A" y "D"
			if direction:
				if is_on_floor() == true:
					get_node("AnimationPlayer").play("caminando") #animar solo si esta en el piso
				velocity.x = direction * SPEED #movimiento multiplicado por direccion (1 o -1)
				if(direction < 0): #modificar a donde apunta el personaje segun su direccion
					get_node("Sprite2D").flip_h = true
					last_direction = direction
				elif (direction > 0):
					get_node("Sprite2D").flip_h = false
					last_direction = direction
					
			else: #si no hay dirrecion: velocidad = 0
				velocity.x = move_toward(velocity.x, 0, SPEED)
				if (is_on_floor() == true and velocity.x == 0):
					get_node("AnimationPlayer").play("idle") #animar estado estatico
				
			if (raycast_cabeza.is_colliding() and colision_hecha == false):
				#revisar si hay una colision en la cabeza y revisar si no se realizo una anteriormente
				var objeto_colisionado = raycast_cabeza.get_collider() #obtener objeto colisionado
				if (objeto_colisionado.is_in_group("cubo")): #si el objeto es un cubo:
					objeto_colisionado.romper_cubo() #romper(abrir) el cubo
					colision_hecha = true
					
				elif(objeto_colisionado.is_in_group("brick") && forma == 0): #si es un ladrillo y mario es p
					objeto_colisionado.activar_cubo() #activar el cubo
					colision_hecha = true
					
				elif(objeto_colisionado.is_in_group("brick") && forma != 0): #si es un ladrillo y mario es g
					objeto_colisionado.romper_cubo() #activar / romper cubo
					colision_hecha = true
			
			if(raycast_pisar.is_colliding() and velocity.y > 0):
				var enemigo_colisionado = raycast_pisar.get_collider()
				if (enemigo_colisionado.is_in_group("enemigos") and enemigo_colisionado.vivo and not enemigo_colisionado.is_in_group("planta")):
					enemigo_colisionado.recibir_golpe()
					velocity.y = - 200
			if(raycast_pisar2.is_colliding() and velocity.y > 0):
				var enemigo_colisionado = raycast_pisar2.get_collider()
				if (enemigo_colisionado.is_in_group("enemigos") and enemigo_colisionado.vivo and not enemigo_colisionado.is_in_group("planta")):
					enemigo_colisionado.recibir_golpe()
					velocity.y = - 200
			if(raycast_pisar3.is_colliding() and velocity.y > 0):
				var enemigo_colisionado = raycast_pisar3.get_collider()
				if (enemigo_colisionado.is_in_group("enemigos") and enemigo_colisionado.vivo and not enemigo_colisionado.is_in_group("planta")):
					enemigo_colisionado.recibir_golpe()
					velocity.y = - 200
					
			if(is_on_floor() and colision_hecha == true): 
				colision_hecha = false #volver a permitir colision cuando mario toca el suelo
		move_and_slide() #activar movimiento
	if(win == true):
		move_and_slide()

func transformar(): #transformar a mario en grande o flor
	get_node("sonidos/agrandar").play()
	if(forma < 2):
		forma += 1 #aumentar un estado a la forma de mario
		get_node("sonidos/agrandar").play()
	if(forma == 1): #modificar sprites de mario segun su forma
		get_node("Sprite2D").texture = mario_g 
	else:
		get_node("Sprite2D").texture = mario_f
	set_colcast() #funcion para cambiar colisiones
		
func destransformar(): #transformar a mario en grande o pequeno
	if(agachado):
		agachado = false
	if(forma > 0 and not inmunity and vivo):
		get_node("sonidos/encojer o tubo").play()
		forma -= 1 #disminuir un estado a la forma de mario
		inmunity = true
		get_node("inmunidad").start()
		get_node("change_visibility").start()
		if(forma == 1): #cambiar texturas de mario segun su forma
			get_node("Sprite2D").texture = mario_g
		else:
			get_node("Sprite2D").texture = mario_p
	elif(not vivo and forma > 0):
		get_node("sonidos/encojer o tubo").play()
		get_node("Sprite2D").texture = mario_p
		forma-=1
	elif(forma == 0 and vivo and not inmunity):
		muerte_mario() #funcion cuando la forma de mario es 0
		forma = -1
		vivo = false
	if(vivo):
		set_colcast() #funcion para cambiar colisiones

func set_colcast():
	
	if(forma > 0 and agachado == false): #si la forma de mario es grande o flor
		colision.set_deferred("disabled", true) #desactivar colisiones actuales
		colision.desactivar_colisiones()
		
		colision = get_node("colision_g") #cambiar colisiones actuales a grandes
		raycast_cabeza = get_node("colision_g/RayCastCabeza") # ""
		raycast_pisar = get_node("colision_g/RayCastPisar") # ""
		raycast_pisar2 = get_node("colision_g/RayCastPisar2")
		raycast_pisar3 = get_node("colision_g/RayCastPisar3")
		
		colision.set_deferred("disabled", false) #activar colisones
		colision.activar_colisiones()
		
	elif(forma == 0 or agachado == true): #si la forma de mario pequena
		colision.set_deferred("disabled", true) #desactivar colisiones actuales
		colision.desactivar_colisiones()
		
		colision = get_node("colision_p") #cambiar colisiones actuales a pequenas
		raycast_cabeza = get_node("colision_p/RayCastCabeza") # ""
		raycast_pisar = get_node("colision_p/RayCastPisar")
		raycast_pisar2 = get_node("colision_p/RayCastPisar2")
		raycast_pisar3 = get_node("colision_p/RayCastPisar3") # ""
		
		colision.set_deferred("disabled", false) #activar colisiones
		colision.activar_colisiones()

func _on_collision_shape_2d_cuerpo_entro(): #revisar que cuerpo entro a mario

	var cuerpo = colision.devolverBody() #funcion para obtener el cuerpo que entro
	if(cuerpo!=null):
		if(cuerpo.is_in_group("hongo") or cuerpo.is_in_group("flor")): #si el cuerpo es un hongo
			if(cuerpo.tipo == 0 && forma == 0): #si el hongo es rojo y mario es p
				transformar()	#transformar a mario
				Gamehandler.agregar_puntuacion(200)
			elif(cuerpo.tipo == 0): #si el hongo es rojo y mario es grande
				get_node("sonidos/agrandar").play()
				Gamehandler.agregar_puntuacion(200)
				
			if(cuerpo.tipo == 1): #si el hongo es verde
				Gamehandler.agregar_vidas(1) #aumentar vidas
				get_node("sonidos/vida extra").play()
			if(cuerpo.tipo == 2): #si el cuerpo es una flor
				Gamehandler.agregar_puntuacion(200)
				if(forma == 0): 
					forma+=1 #si mario es p, agregar un valor a su tamano
				if(forma<2): #si mario no es ya una flor transformar
					transformar()
			cuerpo.queue_free() #eliminar
			
		if(cuerpo.is_in_group("enemigos") and inmunity == false and forma >= 0 and cuerpo.vivo):
			if(cuerpo.is_in_group("koopa")):
				if(not cuerpo.caparazon): #logistica
					destransformar()
			elif(not cuerpo.is_in_group("koopa")):
				destransformar() #quitar vida
				
		if(cuerpo.is_in_group("monedas")):
			cuerpo.queue_free()
			Gamehandler.agregar_monedas(1)
			get_node("sonidos/moneda").play()
		Gamehandler.update_ui()

func muerte_mario(): #muerte mario
	emit_signal("parar_musica")
	get_node("sonidos/morir").play()
	if(vivo):
		vivo = false #setear a mario como muerto
	enabled_movement = false
	get_node("AnimationPlayer").stop() #desactivar animaciones
	if(forma>0):
		destransformar() #convertir a mario en mario p
	get_node("AnimationPlayer").play("muerte") #animar muerte
	inmunity = true

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "muerte"): #emitir senal de muerte al acabar animacion
		emit_signal("muerte")
	if(anim_name == "entrar_tubo_abajo" or anim_name == "entrar_tubo_arriba" or anim_name == "entrar_tubo_izquierda" or anim_name == "entrar_tubo_derecha"):
		emit_signal("warp")
	if(anim_name == "salir_tubo_abajo" or anim_name == "salir_tubo_arriba" or anim_name == "salir_tubo_izquierda" or anim_name == "salir_tubo_derecha"):
		emit_signal("warped")
	if(anim_name == "gotocastle"):
		visible = false
		
func _on_inmunidad_timeout():
	inmunity = false
	get_node("change_visibility").stop()
	if(not visible):
		visible = true

func _on_change_visibility_timeout():
	if(visible):
		visible = false
	else:
		visible = true

func warp_to(pos):
	global_position = pos
	is_pressing_a = false
	is_pressing_w = false
	is_pressing_d = false
	is_pressing_s = false
	if(use_sound):
		get_node("sonidos/encojer o tubo").play()
