extends Node


var party: Array = []


signal party_size_changed(length: int)


func add_to_party(friend: FriendlyNPC) -> void:
	party.push_back(friend)
	party_size_changed.emit(len(party))
