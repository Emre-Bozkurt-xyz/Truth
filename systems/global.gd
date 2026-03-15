extends Node

const OUTLINE = preload("uid://bambsokuuajbs")

var game_controller: GameController
var item_outline: ShaderMaterial
var door_outline: ShaderMaterial

func _ready() -> void:
	item_outline = ShaderMaterial.new()
	item_outline.shader = OUTLINE
	item_outline.set_shader_parameter("width", 3.5)
	item_outline.set_shader_parameter("pattern", 0)
	
	door_outline = ShaderMaterial.new()
	door_outline.shader = OUTLINE
	door_outline.set_shader_parameter("width", 4.5)
	door_outline.set_shader_parameter("pattern", 0)
