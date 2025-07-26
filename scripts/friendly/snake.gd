extends FriendlyNPC


var type: int = Type.SNAKE


func _init() -> void:
	attack = 2
	sneak = 2
	friend = -1
