@tool
extends GameScene

func _ready() -> void:
	if Global.game_controller.game_state == GameController.GameState.MINIGAME:
		await get_tree().process_frame
		Global.game_controller.start_minigame()
	if Global.game_controller.game_state == GameController.GameState.MONSTERS:
		Dialogic.signal_event.connect(_on_signal)


func _on_signal(arg: String):
	if arg == "stab_start":
		Global.player.sprite.visible = false
		$angry_monster.visible = false
		%SCENE.visible = true
	if arg == "stab_stop":
		Global.player.sprite.visible = true
		$angry_monster.visible = true
		%SCENE.visible = false
