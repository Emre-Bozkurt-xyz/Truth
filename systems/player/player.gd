class_name Player
extends CharacterBody2D

@export var speed: float = 280.0
@export var acceleration: float = 20.0
@export var friction: float = 50.0
@export var walk_fps: int = 12

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite

var locked: bool = false
var last_dir: float = 0
var was_idle: bool = true

func _ready() -> void:
	Global.player = self


func _physics_process(_delta: float) -> void:
	if locked:
		animation_player.speed_scale = 1
		animation_player.play("Idle")
		was_idle = true
		velocity.x = 0.0
		return
	
	var dir = Input.get_axis("left", "right")
	
	if dir != 0:
		last_dir = dir
		velocity.x = move_toward(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	sprite.flip_h = last_dir < 0
	if abs(velocity.x) < 30 and not was_idle:
		animation_player.speed_scale = 1
		animation_player.play("Idle")
		was_idle = true
	elif not abs(velocity.x) < 30:
		animation_player.speed_scale = float(walk_fps) / 10.0
		animation_player.play("Walk", -1, abs(velocity.x) / speed)
		was_idle = false
	else:
		animation_player.speed_scale = 1
	
	move_and_slide()
