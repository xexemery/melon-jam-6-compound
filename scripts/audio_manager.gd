extends Node


@onready var main: AudioStreamPlayer = $Main
@onready var battle: AudioStreamPlayer = $Battle


func play_main() -> void:
	battle.stop()
	main.play()


func play_battle() -> void:
	main.stop()
	battle.play()
