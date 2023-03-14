extends CharacterBody2D

@export var SPEED : float = 100
@export var JUMP_VELOCITY : float = -370.0
@export var mario_p : Texture
@export var mario_g : Texture
@export var mario_f : Texture
@onready var colision = get_node("colision_p")
@onready var raycast_cabeza = get_node("colision_p/RayCastCabeza")
@onready var raycast_pisar = get_node("colision_p/RayCastPisar")
var trans_p = load("res://Scenes/colisiones_mario_p.tscn")
var trans_g = load("res://Scenes/colisiones_mario_g.tscn")
var gravity = Gamehandler.gravity
var colision_hecha = false
enum estados {idle, caminando, saltando, muriendo}
var estado_actual = estados
var forma = 0 # 0 = pequeo / 1 = grande / 2 = fuego



func _ready():
	estado_actual = estados.idle
	get_node("colision_g").set_deferred("disabled", true)
	get_node("colision_p").activar_colisiones()

func _physics_process(delta):
	if not is_on_floor():
		estado_actual = estados.saltando
		velocity.y += gravity * delta
		get_node("AnimationPlayer").play("salto")
		
	if Input.is_action_just_pressed("tecla_w") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("tecla_a", "tecla_d")
	if direction:
		estado_actual = estados.caminando
		if is_on_floor() == true:
			get_node("AnimationPlayer").play("caminando")
		velocity.x = direction * SPEED
		if(direction < 0):
			get_node("Sprite2D").flip_h = true
		elif (direction > 0):
			get_node("Sprite2D").flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() == true:
			get_node("AnimationPlayer").play("idle")
	if(Input.is_action_just_released("tecla_a") or Input.is_action_just_released("tecla_d")):
		estado_actual = estados.idle
		
	if (raycast_cabeza.is_colliding() and colision_hecha == false):
		var objeto_colisionado = raycast_cabeza.get_collider()
		if (objeto_colisionado.is_in_group("cubo") or objeto_colisionado.is_in_group("brick")):
			objeto_colisionado.romper_cubo()
			colision_hecha = true
			
	if(is_on_floor() and colision_hecha == true):
		colision_hecha = false
	move_and_slide()

func transformar():
	if(forma < 2):
		forma += 1
	if(forma == 1):
		get_node("Sprite2D").texture = mario_g
	else:
		get_node("Sprite2D").texture = mario_f
	set_colcast()
		
func destransformar():
	if(forma > 0):
		forma -= 1
		if(forma == 1):
			get_node("Sprite2D").texture = mario_g
		else:
			get_node("Sprite2D").texture = mario_p
	else:
		pass #muerte
	set_colcast()

func set_colcast():
	var newColCast
	if(forma > 0):
		colision.set_deferred("disabled", true)
		colision.desactivar_colisiones()
		
		colision = get_node("colision_g")
		raycast_cabeza = get_node("colision_g/RayCastCabeza")
		raycast_pisar = get_node("colision_g/RayCastPisar")
		
		colision.set_deferred("disabled", false)
		colision.activar_colisiones()
	else:
		colision.set_deferred("disabled", true)
		colision.desactivar_colisiones()
		
		colision = get_node("colision_p")
		raycast_cabeza = get_node("colision_p/RayCastCabeza")
		raycast_pisar = get_node("colision_p/RayCastPisar")
		
		colision.set_deferred("disabled", false)
		colision.activar_colisiones()

func _on_collision_shape_2d_cuerpo_entro():
	var cuerpo = colision.devolverBody()
	if(cuerpo!=null):
		if(cuerpo.is_in_group("hongo")):
			print("bonus")
			if(cuerpo.tipo == 0):
				transformar()
				cuerpo.queue_free()
			if(cuerpo.tipo == 1):
				Gamehandler.vidas += 1
