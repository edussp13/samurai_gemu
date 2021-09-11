extends KinematicBody2D

var player = null
var MAX_HEALTH = 3
var health = 3
var can_walk = true

func _ready():
	add_to_group("enemies")

func set_to_player(p):
	player = p

func _physics_process(_delta):
	if player == null:
		return
	
	#se pa um switch fique melhor 
	
	var vec_to_player = player.global_position + Vector2(-6, -40) - global_position
	if can_walk:
		if vec_to_player.y > 5:
			move_and_slide(200 * Vector2(0, 1))
		elif vec_to_player.y < -5:
			move_and_slide(200 * Vector2(0, -1))
		if vec_to_player.x > 5:
			move_and_slide(200 * Vector2(1, 0))
		elif vec_to_player.x < -5:
			move_and_slide(200 * Vector2(-1, 0))

func _on_Hurtbox_area_entered(_area):
	health -= 1
	if health > 0:
		$AnimationPlayer.play("me_derrubaram_aqui")
		var vec_to_player = player.global_position + Vector2(-6, -40) - global_position
		vec_to_player = vec_to_player.normalized()
		vec_to_player = vec_to_player * -10000
		move_and_slide(vec_to_player)
	elif health == 0:
		can_walk = false
		$AnimationPlayer.play("morreno")
	elif health > MAX_HEALTH:
		health = MAX_HEALTH

func animation_over():
	$AnimationPlayer.play("parado")

func death():
	queue_free()
