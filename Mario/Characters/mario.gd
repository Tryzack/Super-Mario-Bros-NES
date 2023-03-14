extends CharacterBody2D

@export var SPEED : float = 100 #velocidad
@export var JUMP_VELOCITY : float = -370.0 #fuerza del salto
@export var mario_p : Texture
@export var mario_g : Texture	#texturas de mario en sus distintas formas
@export var mario_f : Texture
@onready var colision = get_node("colision_p")		#asignar colisiones a mario
@onready var raycast_cabeza = get_node("colision_p/RayCastCabeza")	#asignar colisiones a mario
@onready var raycast_pisar = get_node("colision_p/RayCastPisar")	#asignar colisiones a mario
signal muerte #senal cuando mario muere
var trans_p = load("res://Scenes/colisiones_mario_p.tscn")	#cargar colisiones de los distintos tamanos de mario
var trans_g = load("res://Scenes/colisiones_mario_g.tscn")	#  "" 
var gravity = Gamehandler.gravity #asignar gravedad (valor general para los cuerpos)
var forma : int = 0	# 0 = pequeno / 1 = grande / 2 = fuego
var estado : int = 1	# 0 = muerto / 1 = vivo
var colision_hecha : bool = false #revisar si se realizo una colision
var enabled_movement : bool

func _ready(): #parametros iniciales
	
	enabled_movement = true #activar movimientos
	get_node("colision_g").set_deferred("disabled", true) #desactivar colisiones M_g
	get_node("colision_g").desactivar_colisiones() #desactivar colisiones M_g
	get_node("colision_p").activar_colisiones() #activar colisiones M_p
	
func _physics_process(delta): #movimiento
	
	if(enabled_movement == true):
		
		if not is_on_floor(): #aplicar gravedad
			velocity.y += gravity * delta
			get_node("AnimationPlayer").play("salto") #animar salto
			
		if Input.is_action_just_pressed("tecla_w") and is_on_floor():
			velocity.y = JUMP_VELOCITY #saltar cuando "W" es presionada
		
		var direction = Input.get_axis("tecla_a", "tecla_d") #obtener direccion con "A" y "D"
		if direction:
			if is_on_floor() == true:
				get_node("AnimationPlayer").play("caminando") #animar solo si esta en el piso
			velocity.x = direction * SPEED #movimiento multiplicado por direccion (1 o -1)
			if(direction < 0): #modificar a donde apunta el personaje segun su direccion
				get_node("Sprite2D").flip_h = true
			elif (direction > 0):
				get_node("Sprite2D").flip_h = false
				
		else: #si no hay dirrecion y su velocidad es 0
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor() == true:
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
				
		if(is_on_floor() and colision_hecha == true): 
			colision_hecha = false #volver a permitir colision cuando mario toca el suelo
		if Input.is_action_just_pressed("tecla_espacio"): #(debug only - matar mario) 
			muerte_mario()
			
		move_and_slide() #activar movimiento

func transformar(): #transformar a mario en grande o flor
	if(forma < 2):
		forma += 1 #aumentar un estado a la forma de mario
	if(forma == 1): #modificar sprites de mario segun su forma
		get_node("Sprite2D").texture = mario_g 
	else:
		get_node("Sprite2D").texture = mario_f
	set_colcast() #funcion para cambiar colisiones
		
func destransformar(): #transformar a mario en grande o pequeno
	if(forma > 0):
		forma -= 1 #disminuir un estado a la forma de mario
		if(forma == 1): #cambiar texturas de mario segun su forma
			get_node("Sprite2D").texture = mario_g
		else:
			get_node("Sprite2D").texture = mario_p
	else:
		muerte_mario() #funcion cuando la forma de mario es 0
	set_colcast() #funcion para cambiar colisiones

func set_colcast():
	
	if(forma > 0): #si la forma de mario es grande o flor
		colision.set_deferred("disabled", true) #desactivar colisiones actuales
		colision.desactivar_colisiones()
		
		colision = get_node("colision_g") #cambiar colisiones actuales a grandes
		raycast_cabeza = get_node("colision_g/RayCastCabeza") # ""
		raycast_pisar = get_node("colision_g/RayCastPisar") # ""
		
		colision.set_deferred("disabled", false) #activar colisones
		colision.activar_colisiones()
		
	else: #si la forma de mario pequena
		colision.set_deferred("disabled", true) #desactivar colisiones actuales
		colision.desactivar_colisiones()
		
		colision = get_node("colision_p") #cambiar colisiones actuales a pequenas
		raycast_cabeza = get_node("colision_p/RayCastCabeza") # ""
		raycast_pisar = get_node("colision_p/RayCastPisar") # ""
		
		colision.set_deferred("disabled", false) #activar colisiones
		colision.activar_colisiones()

func _on_collision_shape_2d_cuerpo_entro(): #revisar que cuerpo entro a mario
	var cuerpo = colision.devolverBody() #funcion para obtener el cuerpo que entro
	if(cuerpo!=null):
		if(cuerpo.is_in_group("hongo")): #si el cuerpo es un hongo
			print("bonus")
			if(cuerpo.tipo == 0 && forma == 0): #si el hongo es rojo y mario es p
				transformar()	#transformar a mario
				cuerpo.queue_free() #eliminar cuerpo
			elif(cuerpo.tipo == 0):
				pass #(por hacer: emitir senal que de bonus de puntuacion o monedas?)
			if(cuerpo.tipo == 1): #si el hongo es verde
				Gamehandler.vidas += 1 #aumentar vidas

func muerte_mario(): #muerte mario
	enabled_movement = false
	get_node("AnimationPlayer").stop() #desactivar animaciones
	if(forma>0):
		destransformar() #convertir a mario en mario p
	get_node("AnimationPlayer").play("muerte") #animar muerte


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "muerte"): #emitir senal de muerte al acabar animacion
		emit_signal("muerte")
