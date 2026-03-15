extends Control

signal entered

@export var fade_time: float = 0.4

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var fading_in: bool = false

func _ready() -> void:
	visible = false

func enter():
	visible = true
	animation_player.speed_scale = 1.0 / fade_time
	animation_player.play("fade_in")
	fading_in = true
	
	await animation_player.animation_finished
	fading_in = false
	entered.emit()

func exit():
	if fading_in:
		await entered
	
	animation_player.speed_scale = 1.0 / fade_time
	animation_player.play_backwards("fade_in")
	
	await animation_player.animation_finished
	visible = false
