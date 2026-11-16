extends Area2D

@export_file("*.tscn") var escena_destino: String = ""
@export var punto_spawn_destino: String = ""
@export var bloqueada: bool = false

@onready var contorno: Node2D = $Contorno

var jugador_cerca: bool = false
var cambiando: bool = false

func _ready():
	if contorno:
		contorno.visible = false

func set_bloqueada(valor: bool) -> void:
	bloqueada = valor
	if contorno:
		contorno.visible = (not bloqueada) and jugador_cerca

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true
		if contorno and not bloqueada:
			contorno.visible = true

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		if contorno:
			contorno.visible = false

func _unhandled_input(event):
	if bloqueada or CajaDialogo.visible:
		return
	if jugador_cerca and not cambiando:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E):
			cambiando = true
			Global.punto_spawn = punto_spawn_destino
			get_viewport().set_input_as_handled()
			get_tree().call_deferred("change_scene_to_file", escena_destino)
