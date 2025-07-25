extends Area2D


@onready var energy_bar: TextureProgressBar = %EnergyBar


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		energy_bar.eat_food()
		queue_free()
