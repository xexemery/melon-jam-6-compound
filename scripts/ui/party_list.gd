extends GridContainer


@onready var crab: TextureRect = $Crab
@onready var dog: TextureRect = $Dog
@onready var octopus: TextureRect = $Octopus
@onready var rat: TextureRect = $Rat
@onready var slime: TextureRect = $Slime
@onready var snake: TextureRect = $Snake
@onready var tortoise: TextureRect = $Tortoise

var members: Array[TextureRect] = []
var new_member: TextureRect


func add_party_member(type: int) -> void:
	match type:
		0:
			new_member = crab.duplicate()
		1:
			new_member = dog.duplicate()
		2:
			new_member = octopus.duplicate()
		3:
			new_member = rat.duplicate()
		4:
			new_member = slime.duplicate()
		5:
			new_member = snake.duplicate()
		6:
			new_member = tortoise.duplicate()

	new_member.show()
	add_child(new_member)
	members.push_back(new_member)
