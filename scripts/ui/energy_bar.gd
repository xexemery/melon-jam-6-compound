extends TextureProgressBar


@onready var game_manager: Node = %GameManager
@onready var text_box: CanvasLayer = %TextBox

const DRAIN_RATE: int = 1
var party_size: int = 0
var index_to_remove: int


func _ready() -> void:
	value_changed.connect(_check_energy)
	game_manager.party_size_changed.connect(_update_party_size)


func drain_energy() -> void:
	value -= DRAIN_RATE * (party_size + 1) # add 1 to account for player


func eat_food() -> void:
	value += 50


func _check_energy(energy) -> void:
	if energy:
		return

	if party_size == 0:
		game_manager.game_over()
	else:
		_eat_party_member()


func _update_party_size(length: int) -> void:
	party_size = length


func _eat_party_member() -> void:
	value += 50
	index_to_remove = randi_range(1, party_size) - 1
	game_manager.remove_from_party(index_to_remove)
