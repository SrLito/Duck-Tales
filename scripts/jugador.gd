class_name Jugador
extends CharacterBody2D

@export var velocidad = 100
@export var salto = -100
@export var gravedad = 980
@export var saltoPogo = -500

# Variables de estado del personaje.
var saltoBaston = false
var colisionCuerda = false
var estaColgado = false

func _physics_process(delta):
	
	# Movimiento horizontal.
	var direccion = Input.get_axis("izquierda" , "derecha")
	
	# Si el personaje no esta colgado de la cuerda, le permite moverse.
	if not estaColgado:
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
	
	# Mécanica de la cuerda.
	
	# Agarrar la cuerda.
	if colisionCuerda and (Input.is_action_just_pressed("bajar") or Input.is_action_just_pressed("subir")) :
		estaColgado = true
		velocity.x = 0
		velocity.y = 0
		gravedad = 0
		
	 
	if estaColgado:
		if Input.is_action_just_pressed("subir"):
			velocity.y = -100
		if Input.is_action_just_released("subir"):
			velocity.y = 0
		if Input.is_action_pressed("bajar"):
			velocity.y = 100
		if Input.is_action_just_released("bajar"):
			velocity.y = 0
			
	# Soltar la cuerda.
	if estaColgado:
		if Input.is_action_just_pressed("saltar"):
			estaColgado = false
			gravedad = 980

	print(gravedad)
	move_and_slide()    
  	


func _on_cuerda_body_entered(_body: Node2D) -> void:
	# Estado del personaje con respecto a la cuerda.
	colisionCuerda = true
func _on_cuerda_body_exited(_body: Node2D) -> void:
	# Estado del personaje con respecto a la cuerda.
	colisionCuerda = false
	#Si el personaje sale de la cuerda.
	estaColgado = false
	gravedad = 980
	
