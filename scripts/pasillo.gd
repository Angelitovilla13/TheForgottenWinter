extends Node2D

const DIALOGOS_MAMA: Array[String] = [
	"Mamá al teléfono: No lo sé Erick, ella sigue actuando de lo más normal, no sé qué voy a hacer.",
	"Mamá al teléfono: Yo sola no puedo con esto...",
	"Sherlyn: (Y nadie habla del hecho de que mi hermana se volvió loca, solo soy yo el problema.)",
]

const DIALOGOS_HERMANA: Array[String] = [
	"Sherlyn: (La puerta de mi hermana siempre está bajo llave.)",
]

@onready var puerta_mama: Area2D = $PuertaMama
@onready var contorno_mama: Node2D = $PuertaMama/Contorno
@onready var puerta_hermana: Area2D = $PuertaHermana
@onready var contorno_hermana: Node2D = $PuertaHermana/Contorno
@onready var puerta_cuarto: Area2D = $PuertaCuarto

var paso_pasillo: int = 0
var jugador_en_puerta_mama: bool = false
var jugador_en_puerta_hermana: bool = false
var _evento_en_curso: int = -1


func _ready():
	if Global.punto_spawn == "desde_cocina":
		$Jugador.position = Vector2(380, 580)
		$Jugador/Animacion.flip_h = false
		Global.punto_spawn = ""
	elif Global.punto_spawn == "desde_cuartoprota":
		$Jugador.position = Vector2(540, 480)
		$Jugador/Animacion.flip_h = false
		Global.punto_spawn = ""

	contorno_mama.visible = false
	contorno_hermana.visible = false

	if Global.pasillo_completado:
		paso_pasillo = 2
		puerta_cuarto.set_bloqueada(false)
	else:
		paso_pasillo = 0
		puerta_cuarto.set_bloqueada(true)

	puerta_mama.body_entered.connect(_on_puerta_mama_body_entered)
	puerta_mama.body_exited.connect(_on_puerta_mama_body_exited)
	puerta_hermana.body_entered.connect(_on_puerta_hermana_body_entered)
	puerta_hermana.body_exited.connect(_on_puerta_hermana_body_exited)
	CajaDialogo.secuencia_terminada.connect(_on_dialogo_secuencia_terminada)


func _unhandled_input(event: InputEvent) -> void:
	if CajaDialogo.visible or _evento_en_curso != -1:
		return

	if event.is_action_pressed("ui_accept"):
		if paso_pasillo == 0 and jugador_en_puerta_mama:
			contorno_mama.visible = false
			_evento_en_curso = 0
			CajaDialogo.mostrar_secuencia(DIALOGOS_MAMA)
			get_viewport().set_input_as_handled()
		elif paso_pasillo == 1 and jugador_en_puerta_hermana:
			contorno_hermana.visible = false
			_evento_en_curso = 1
			CajaDialogo.mostrar_secuencia(DIALOGOS_HERMANA)
			get_viewport().set_input_as_handled()


func _on_puerta_mama_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_en_puerta_mama = true
		if paso_pasillo == 0 and _evento_en_curso == -1:
			contorno_mama.visible = true


func _on_puerta_mama_body_exited(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_en_puerta_mama = false
		contorno_mama.visible = false


func _on_puerta_hermana_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_en_puerta_hermana = true
		if paso_pasillo == 1 and _evento_en_curso == -1:
			contorno_hermana.visible = true


func _on_puerta_hermana_body_exited(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_en_puerta_hermana = false
		contorno_hermana.visible = false


func _on_dialogo_secuencia_terminada() -> void:
	if _evento_en_curso == 0:
		_evento_en_curso = -1
		paso_pasillo = 1
		if jugador_en_puerta_hermana:
			contorno_hermana.visible = true
	elif _evento_en_curso == 1:
		_evento_en_curso = -1
		paso_pasillo = 2
		Global.pasillo_completado = true
		puerta_cuarto.set_bloqueada(false)
