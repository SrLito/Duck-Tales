class_name Jugador
extends CharacterBody2D

@export var velocidad = 100
@export var salto = -100
@export var gravedad = 980
@export var saltoPogo = -500
@export var cortarSalto = 0.01

# Variables de estado del personaje.
var saltoBaston = false
var colisionCuerda = false
var colgadoCuerda = false
var colisionAro = false
var estaColgado = false

# Funciones de la maquina de estados. // MAS ADELANTE LAS AGREGO
#func estadoReposo(active:bool):
#func estadoCorrer(active:bool):
#func estadoSaltar(active:bool):
#func estadoSaltarPogo(active:bool):
#func estadoAtacar(active:bool):
#func estadoColgar(active:bool):
#func estadoAgachar(active:bool):

func _physics_process(delta):

	## MOVIMIENTO HORIZONTAL
	var direccion = Input.get_axis("izquierda" , "derecha")
	# Si el personaje no esta colgado de la cuerda, le permite moverse.
	if not estaColgado:
		velocity.x = velocidad * direccion
	# Mirar a izquierda o derecha
	if direccion != 0:
		$Sprite2D.scale.x = direccion

	## GRAVEDAD
	if not is_on_floor() and not estaColgado:
		velocity.y = velocity.y + gravedad * delta

	## MÉCANICA DE SALTO
	# Salto simple
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = velocity.y + salto
	# Ajuste de salto variable
	if Input.is_action_just_released("saltar") and velocity.y < 0:
		velocity.y = velocity.y * cortarSalto
	# Si esta en el aire y presiona "espacio" activo bandera.
	if Input.is_action_pressed("saltar") and not is_on_floor() and not estaColgado:
		saltoBaston = true
	# Al soltar "espacio" desactivo bandera.
	if Input.is_action_just_released("saltar"):
		saltoBaston = false 
	# Realizo el salto con bastón.
	if is_on_floor() and saltoBaston:
		velocity.y = velocity.y - 1000
	
	## MÉCANICA DE COLGARSE.
	# Agarrar la cuerda o aro.
	if (colisionCuerda or colisionAro) and (Input.is_action_just_pressed("bajar") or Input.is_action_just_pressed("subir")) :
		estaColgado = true
		velocity = Vector2.ZERO
	 # Subir o bajar por la cuerda.
	if estaColgado and colgadoCuerda:
		var direccion_cuerda = Input.get_axis("subir", "bajar")
		velocity.y = direccion_cuerda * 100
	# Soltar la cuerda.
	if estaColgado:
		if Input.is_action_just_pressed("saltar"):
			velocity.y = velocity.y + salto
			estaColgado = false
	
	move_and_slide()    

# Personaje colisiona con la cuerda.
func _on_cuerda_body_entered(_body: Node2D) -> void:
	# Estado del personaje con respecto a la cuerda.
	colisionCuerda = true
	colgadoCuerda = true
	
# Personaje sale de la colision con la cuerda.
func _on_cuerda_body_exited(_body: Node2D) -> void:
	# Estado del personaje con respecto a la cuerda.
	colisionCuerda = false
	# Si el personaje sale de la cuerda.
	estaColgado = false
	colgadoCuerda = false

# Personaje colisiona con el aro.
func _on_aro_body_entered(_body: Node2D) -> void:
	# Estado del personaje con respecto al aro.
	colisionAro = true

# Personaje sale de la colision con el aro.
func _on_aro_body_exited(body: Node2D) -> void:
	# Si el personaje sale del aro.
	colisionAro = false
