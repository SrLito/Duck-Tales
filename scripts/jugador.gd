class_name Jugador
extends CharacterBody2D

@export var velocidad = 100
@export var salto = -100
@export var gravedad = 980

func _physics_process(delta):
	
	# Movimiento horizontal.
	var direccion = Input.get_axis("izquierda" , "derecha")
	velocity.x = velocidad * direccion
		
	# Aplico gravedad al personaje.
	if not is_on_floor():
		velocity.y = velocity.y + gravedad * delta
	
	# Aplico mecanica de salto.
	if is_on_floor() and Input.is_action_just_pressed("saltar"):
		velocity.y = velocity.y + salto
		print("salta")
	move_and_slide()	
