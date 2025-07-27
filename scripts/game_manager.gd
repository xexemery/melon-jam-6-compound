extends Node


@onready var party_stats: VBoxContainer = %PartyStats
@onready var party_list: GridContainer = %PartyList
@onready var text_box: CanvasLayer = %TextBox

var party: Array[FriendlyNPC] = []
var party_attack: int = 1
var party_defend: int = 1
var party_sneak: int = 1
var party_friend: int = 1
var member_to_remove: FriendlyNPC


signal party_size_changed(length: int)


func add_to_party(member: FriendlyNPC) -> void:
	party.push_back(member)

	party_attack += member.attack
	party_defend += member.defend
	party_sneak += member.sneak
	party_friend += member.friend

	party_stats.display_stats()
	party_list.add_party_member(member.type)

	party_size_changed.emit(len(party))


func remove_from_party(index: int) -> void:
	member_to_remove = party.pop_at(index)

	party_attack -= member_to_remove.attack
	party_defend -= member_to_remove.defend
	party_sneak -= member_to_remove.sneak
	party_friend -= member_to_remove.friend

	party_stats.display_stats()
	party_list.remove_party_member(index)

	# maybe update this to say something different if it happens via enemy attack
	text_box.queue_text(member_to_remove.get_type() + " was consumed.")
	party_size_changed.emit(len(party))


func game_over(starved: bool) -> void:
	if starved:
		text_box.queue_text("You starved...")
	else:
		text_box.kill_options()
		text_box.queue_text("You were defeated...")
	text_box.queue_text("Try again.")

	await text_box.text_finished
	get_tree().reload_current_scene()


func win() -> void:
	text_box.queue_text("You escaped the compound...")
	text_box.queue_text("But the creatures you absorbed were not so lucky...")
	text_box.queue_text("Creatures absorbed: ")
	text_box.queue_text("Creatures consumed: ")
	text_box.queue_text("You return to the earth... Where you belong.")
