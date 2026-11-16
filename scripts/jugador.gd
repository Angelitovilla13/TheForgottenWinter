extends CharacterBody2D

const VELOCIDAD = 250.0

# --- VARIABLES DE PROFUNDIDAD ---
# --- VARIABLES DE PROFUNDIDAD ---
@export var ESCALA_FONDO: float = 0.5
@export var ESCALA_FRENTE: float = 1.0
@export var Y_FONDO: float = 286.0
@export var Y_FRENTE: float = 570.0

func _physics_process(delta):
	# 1. CÓDIGO DE PROFUNDIDAD PRIMERO (Para saber qué tan lejos está)
	var porcentaje = (position.y - Y_FONDO) / (Y_FRENTE - Y_FONDO)
	porcentaje = clamp(porcentaje, 0.0, 1.0)
	var tamano = lerp(ESCALA_FONDO, ESCALA_FRENTE, porcentaje)
	scale = Vector2(tamano, tamano)
	
	# 2. MOVIMIENTO CON PERSPECTIVA
	var direccion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# TRUCO 1: Reducir la velocidad del eje Y permanentemente (simula el piso inclinado)
	# Un valor de 0.6 significa que en vertical se mueve al 60% de su velocidad horizontal
	direccion.y *= 0.6 
	
	# TRUCO 2: La velocidad final se multiplica por su tamaño
	velocity = direccion * (VELOCIDAD * tamano)
	move_and_slide()
	
	# 3. ANIMACIONES Y GIRO
	if direccion != Vector2.ZERO:
		$Animacion.play("caminar")
		if direccion.x != 0:
			$Animacion.flip_h = direccion.x < 0
	else:
		$Animacion.play("idle")
	
	# 4. SONIDO DE PASOS
	var esta_caminando: bool = velocity.length() > 10.0 and not CajaDialogo.visible
	if esta_caminando:
		if $AudioPasos.stream_paused:
			$AudioPasos.stream_paused = false
		elif not $AudioPasos.playing:
			$AudioPasos.play()
	else:
		if $AudioPasos.playing and not $AudioPasos.stream_paused:
			$AudioPasos.stream_paused = true
