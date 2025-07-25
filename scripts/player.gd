extends CharacterBody2D


@onready var up: RayCast2D = $Up
@onready var down: RayCast2D = $Down
@onready var left: RayCast2D = $Left
@onready var right: RayCast2D = $Right
@onready var sprite: Sprite2D = $Sprite2D
@onready var energy_bar: TextureProgressBar = %EnergyBar

var ray_casts: Array[RayCast2D]

const TILE_SIZE: Vector2 = Vector2(8, 8)
var sprite_node_pos_tween: Tween


func _ready() -> void:
	ray_casts = [up, down, left, right]
	print(ray_casts)


func _physics_process(_delta: float) -> void:
	if sprite_node_pos_tween and sprite_node_pos_tween.is_running():
		return

	# Handle movement
	if Input.is_action_pressed("up") and !up.is_colliding():
		_move(Vector2(0, -1))
	elif Input.is_action_pressed("down") and !down.is_colliding():
		_move(Vector2(0, 1))
	elif Input.is_action_pressed("left") and !left.is_colliding():
		_move(Vector2(-1, 0))
	elif Input.is_action_pressed("right") and !right.is_colliding():
		_move(Vector2(1, 0))

	# Handle interactions
	if Input.is_action_just_pressed("interact"):
		var colliding_index: int = ray_casts.find_custom(_check_collider_is_NPC)
		if colliding_index >= 0:
			var collider: NPC = ray_casts[colliding_index].get_collider()
			collider.interact()


func _move(direction: Vector2) -> void:
	global_position += direction * TILE_SIZE
	sprite.global_position -= direction * TILE_SIZE

	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()

	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property(sprite, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)

	energy_bar.drain_energy()


func _check_collider_is_NPC(ray_cast: RayCast2D) -> bool:
	return ray_cast.is_colliding() and ray_cast.get_collider() is NPC
