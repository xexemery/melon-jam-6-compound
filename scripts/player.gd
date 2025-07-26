extends CharacterBody2D


@onready var up: RayCast2D = $Up
@onready var down: RayCast2D = $Down
@onready var left: RayCast2D = $Left
@onready var right: RayCast2D = $Right
@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var energy_bar: TextureProgressBar = %EnergyBar
@onready var text_box: CanvasLayer = %TextBox

const TILE_SIZE: Vector2 = Vector2(8, 8)
var sprite_tween: Tween
var current_target: NPC


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	text_box.queue_text("Hungry...")


func _physics_process(_delta: float) -> void:
	if sprite_tween and sprite_tween.is_running():
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
	if Input.is_action_just_pressed("interact") and current_target is NPC:
		current_target.interact()


func _move(direction: Vector2) -> void:
	global_position += direction * TILE_SIZE
	sprite.global_position -= direction * TILE_SIZE

	if sprite_tween:
		sprite_tween.kill()

	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property(sprite, "global_position", global_position, 0.2).set_trans(Tween.TRANS_SINE)

	energy_bar.drain_energy()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is FriendlyNPC:
		body.get_node("SpeechBubble").show()
		current_target = body
	elif body is EnemyNPC:
		body.get_node("AttackSymbol").show()
		current_target = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is FriendlyNPC:
		body.get_node("SpeechBubble").hide()
		current_target = null
	elif body is EnemyNPC:
		body.get_node("AttackSymbol").hide()
		current_target = null
