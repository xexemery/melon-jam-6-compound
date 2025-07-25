extends CharacterBody2D


@onready var up: RayCast2D = $Up
@onready var down: RayCast2D = $Down
@onready var left: RayCast2D = $Left
@onready var right: RayCast2D = $Right
@onready var sprite: Sprite2D = $Sprite2D
@onready var energy_bar: TextureProgressBar = %EnergyBar


const TILE_SIZE: Vector2 = Vector2(8, 8)
var sprite_node_pos_tween: Tween


func _physics_process(_delta: float) -> void:
	if !sprite_node_pos_tween or !sprite_node_pos_tween.is_running():
		if Input.is_action_pressed("up") and !up.is_colliding():
			_move(Vector2(0, -1))
		elif Input.is_action_pressed("down") and !down.is_colliding():
			_move(Vector2(0, 1))
		elif Input.is_action_pressed("left") and !left.is_colliding():
			_move(Vector2(-1, 0))
		elif Input.is_action_pressed("right") and !right.is_colliding():
			_move(Vector2(1, 0))


func _move(direction: Vector2):
	global_position += direction * TILE_SIZE
	sprite.global_position -= direction * TILE_SIZE

	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()

	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property(sprite, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)

	energy_bar.drain_energy()
