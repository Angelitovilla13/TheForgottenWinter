extends CanvasLayer

signal secuencia_terminada

@onready var texto: RichTextLabel = $Panel/Texto
@onready var timer_letras: Timer = $TimerLetras

var _cola_dialogos: Array[String] = []


func _ready() -> void:
	# Iniciar oculto y sin procesar entrada hasta que se muestre un diálogo
	visible = false
	set_process_unhandled_input(false)

	# Asegurar que el Timer se repita por cada carácter y conectar su señal por código
	timer_letras.one_shot = false
	timer_letras.timeout.connect(_on_timer_letras_timeout)


func mostrar_dialogo(nuevo_texto: String) -> void:
	_cola_dialogos.clear()
	_mostrar_linea(nuevo_texto)


func mostrar_secuencia(lista_dialogos: Array[String]) -> void:
	if lista_dialogos.is_empty():
		return
	_cola_dialogos = lista_dialogos.duplicate()
	var primer_texto: String = _cola_dialogos.pop_front()
	_mostrar_linea(primer_texto)


func _mostrar_linea(nuevo_texto: String) -> void:
	visible = true
	texto.text = nuevo_texto
	texto.visible_characters = 0
	set_process_unhandled_input(true)
	timer_letras.start()


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_accept"):
		if not timer_letras.is_stopped():
			# Saltar animación y mostrar todo el texto de golpe
			texto.visible_characters = -1
			timer_letras.stop()
		elif not _cola_dialogos.is_empty():
			# Mostrar el siguiente diálogo de la cola sin cerrar la caja
			var siguiente_texto: String = _cola_dialogos.pop_front()
			_mostrar_linea(siguiente_texto)
		else:
			# Cerrar la caja de diálogo
			timer_letras.stop()
			visible = false
			texto.text = ""
			set_process_unhandled_input(false)
			secuencia_terminada.emit()

		# Evitar que la misma pulsación active otros nodos detrás del diálogo
		get_viewport().set_input_as_handled()


func _on_timer_letras_timeout() -> void:
	texto.visible_characters += 1
	if texto.visible_characters >= texto.get_total_character_count():
		timer_letras.stop()
