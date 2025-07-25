extends TextureProgressBar


func _ready() -> void:
	value_changed.connect(_check_energy)


func _check_energy(energy) -> void:
	if energy == 0:
		print("you died")


func drain_energy() -> void:
	value -= 5


func eat_food() -> void:
	value += 50
