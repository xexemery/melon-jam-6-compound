extends Node


@onready var party_stats: VBoxContainer = %PartyStats

var party: Array = []
var party_attack: int = 1
var party_defend: int = 1
var party_sneak: int = 1
var party_friend: int = 1


signal party_size_changed(length: int)


func add_to_party(member: FriendlyNPC) -> void:
	party.push_back(member.type)

	party_attack += member.attack
	party_defend += member.defend
	party_sneak += member.sneak
	party_friend += member.friend

	party_stats.update_stats(party_attack, party_defend, party_sneak, party_friend)
	party_size_changed.emit(len(party))
