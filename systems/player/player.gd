class_name Player
extends CharacterBody2D

@export var speed: float = 280.0
@export var acceleration: float = 20.0
@export var friction: float = 50.0

@onready var sprite: Sprite2D = $Sprite

var locked: bool = false
var last_dir: float = 0

func _ready() -> void:
	Global.player = self


func _physics_process(_delta: float) -> void:
	if locked:
		velocity.x = 0.0
		return
	
	var dir = Input.get_axis("left", "right")
	
	if dir != 0:
		last_dir = dir
		velocity.x = move_toward(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	sprite.flip_h = last_dir < 0
	
	move_and_slide()
