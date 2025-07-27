extends Node


@onready var main: AudioStreamPlayer = $Main
@onready var battle: AudioStreamPlayer = $Battle
@onready var eat: AudioStreamPlayer = $Eat


func play_main() -> void:
	battle.stop()
	main.play()


func play_battle() -> void:
	main.stop()
	battle.play()


func play_eat() -> void:
	eat.play()
