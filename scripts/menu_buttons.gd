extends Control

signal continuar_pressed
signal nueva_partida_pressed
signal ajustes_pressed
signal salir_pressed

@onready var btn_continuar: TextureButton = $ButtonsContainer/BtnContinuar
@onready var btn_nueva_partida: TextureButton = $ButtonsContainer/BtnNuevaPartida
@onready var btn_ajustes: TextureButton = $ButtonsContainer/BtnAjustes
@onready var btn_salir: TextureButton = $ButtonsContainer/BtnSalir
@onready var cursor: TextureRect = $Cursor

var buttons: Array[TextureButton] = []
var current_index: int = 0
var cursor_base_x: float = 6.0

# Color blanco grisáceo frío con 90% de opacidad (alpha = 0.90)
const COLOR_NORMAL = Color(0.88, 0.90, 0.92, 0.90)
const COLOR_HOVER = Color(1.18, 1.20, 1.22, 1.0) # Blanco brillante para el elemento activo

func _ready() -> void:
	buttons = [btn_continuar, btn_nueva_partida, btn_ajustes, btn_salir]
	
	if cursor:
		cursor_base_x = cursor.position.x
	
	for i in range(buttons.size()):
		var btn = buttons[i]
		btn.mouse_entered.connect(_on_button_hovered.bind(i))
		btn.pivot_offset = Vector2(0, btn.size.y / 2.0)
		btn.modulate = COLOR_NORMAL
		btn.scale = Vector2.ONE
	
	btn_continuar.pressed.connect(_on_continuar_pressed)
	btn_nueva_partida.pressed.connect(_on_nueva_partida_pressed)
	btn_ajustes.pressed.connect(_on_ajustes_pressed)
	btn_salir.pressed.connect(_on_salir_pressed)
	
	select_button(0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		select_button((current_index + 1) % buttons.size())
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_up"):
		select_button((current_index - 1 + buttons.size()) % buttons.size())
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		if current_index >= 0 and current_index < buttons.size():
			buttons[current_index].emit_signal("pressed")
			get_viewport().set_input_as_handled()

func select_button(index: int) -> void:
	current_index = index
	for i in range(buttons.size()):
		var btn = buttons[i]
		btn.scale = Vector2.ONE
		if i == current_index:
			btn.modulate = COLOR_HOVER
		else:
			btn.modulate = COLOR_NORMAL
			
	# Cursor estático posicionado directamente junto al botón activo
	if cursor and buttons.size() > index:
		var target_btn = buttons[index]
		var rel_y = target_btn.position.y + (target_btn.size.y - cursor.size.y) / 2.0
		var container = $ButtonsContainer
		if container:
			rel_y += container.position.y
		cursor.position.x = cursor_base_x
		cursor.position.y = rel_y

func _on_button_hovered(index: int) -> void:
	select_button(index)

func _on_continuar_pressed() -> void:
	print("[Menu] CONTINUAR pulsado")
	continuar_pressed.emit()

func _on_nueva_partida_pressed() -> void:
	print("[Menu] NUEVA PARTIDA pulsado")
	nueva_partida_pressed.emit()

func _on_ajustes_pressed() -> void:
	print("[Menu] AJUSTES pulsado")
	ajustes_pressed.emit()

func _on_salir_pressed() -> void:
	print("[Menu] SALIR pulsado")
	salir_pressed.emit()
	var tween = create_tween()
	tween.tween_interval(0.15)
	tween.tween_callback(func(): get_tree().quit())
