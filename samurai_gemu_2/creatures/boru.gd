extends KinematicBody2D

enum {
	GROUNDED,
	JUMPING
}

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var player = null
var health = 3
var MAX_HEALTH = 3
var can_walk = true
var vec_to_player = Vector2.ZERO
var state = GROUNDED

func _ready():
	add_to_group("enemies")

func set_to_player(p):
	player = p

func _physics_process(_delta):
	match state:
		GROUNDED:
			ground()
		JUMPING:
			jumping()
	
func ground():
	if player == null:
		return

	vec_to_player = player.global_position + Vector2(-6, -40) - global_position
	vec_to_player = vec_to_player.normalized()
	animationTree.set("parameters/Idle/blend_position", vec_to_player)
	animationTree.set("parameters/Jump/blend_position", vec_to_player)
	animationState.travel("Jump")
	#state = JUMPING

func jumping():
	state = JUMPING
	if can_walk:
		move_and_slide(vec_to_player * 400)

func to_ground():
	state = GROUNDED

func _on_Hurtbox_area_entered(_area):
	#generalizar para todos os monstros
	health -= 1
	if health > 0:
		var vec_to_player = player.global_position + Vector2(-6, -40) - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_slide(vec_to_player * -10000)
	elif health == 0:
		can_walk = false
		animationPlayer.play("my_final_massage")
	if health > MAX_HEALTH:
		health = MAX_HEALTH

func death():
	queue_free()

