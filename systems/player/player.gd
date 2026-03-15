class_name Player
extends CharacterBody2D

@export var speed: float = 240.0
@export var acceleration: float = 10.0
@export var friction: float = 20.0

var locked: bool = false

func _ready() -> void:
	Global.player = self


func _physics_process(_delta: float) -> void:
	if locked:
		velocity.x = 0.0
		return
	
	var dir = Input.get_axis("left", "right")
	
	if dir != 0:
		velocity.x = move_toward(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	move_and_slide()
