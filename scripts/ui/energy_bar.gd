extends TextureProgressBar


@onready var game_manager: Node = %GameManager

var party_size: int = 1


func _ready() -> void:
	value_changed.connect(_check_energy)
	game_manager.party_size_changed.connect(_update_party_size)


func drain_energy() -> void:
	value -= 2 * party_size


func eat_food() -> void:
	value += 50


func _check_energy(energy) -> void:
	if energy == 0:
		print("you died")


func _update_party_size(length: int) -> void:
	party_size = length + 1 # add 1 to account for player
