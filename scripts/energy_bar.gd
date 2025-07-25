extends TextureProgressBar


func _process(_delta: float) -> void:
	if value == 0:
		print("you died") # also do something to stop infinitely doing this


func drain_energy() -> void:
	value -= 5


func eat_food() -> void:
	value += 50
