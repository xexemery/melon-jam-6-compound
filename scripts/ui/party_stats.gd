extends VBoxContainer


@onready var game_manager: Node = %GameManager
@onready var attack_value: Label = $AttackValue
@onready var defend_value: Label = $DefendValue
@onready var sneak_value: Label = $SneakValue
@onready var friend_value: Label = $FriendValue


func _ready() -> void:
	display_stats()


func display_stats() -> void:
	attack_value.text = str(game_manager.party_attack)
	defend_value.text = str(game_manager.party_defend)
	sneak_value.text = str(game_manager.party_sneak)
	friend_value.text = str(game_manager.party_friend)
