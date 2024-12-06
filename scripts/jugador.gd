class_name Jugador
extends CharacterBody2D

@export var velocidad = 100
@export var salto = -100
@export var gravedad = 980
@export var saltoPogo = -500

var saltoBaston = false

func _physics_process(delta):
	
	# Movimiento horizontal.
	var direccion = Input.get_axis("izquierda" , "derecha")
	velocity.x = velocidad * direccion
	
	# Mirar a izquierda o derecha
	if direccion != 0:
		$Sprite2D.scale.x = direccion
		
	# Aplico gravedad al personaje.
	if not is_on_floor():
		velocity.y = velocity.y + gravedad * delta
	
	# Aplico mecanica de salto.
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = velocity.y + salto
	# Si esta en el aire y presiona "espacio" activo bandera.
	if Input.is_action_just_pressed("saltar") and not is_on_floor():
		saltoBaston = true
	# Al soltar "espacio" desactivo bandera.
	if Input.is_action_just_released("saltar"):
		saltoBaston = false
	# Realizo el salto con bastón.
	if is_on_floor() and saltoBaston:
		velocity.y = velocity.y - 1000
	
	move_and_slide()
	
