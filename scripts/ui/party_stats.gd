extends VBoxContainer


@onready var attack_value: Label = $AttackValue
@onready var defend_value: Label = $DefendValue
@onready var sneak_value: Label = $SneakValue
@onready var friend_value: Label = $FriendValue


func update_stats(attack: int, defend: int, sneak: int, friend: int) -> void:
	attack_value.text = str(attack)
	defend_value.text = str(defend)
	sneak_value.text = str(sneak)
	friend_value.text = str(friend)
