extends KinematicBody2D

var player = null
var health = 5
var MAX_HEALTH = 5
var can_walk = true

func _ready():
	add_to_group("enemies")

func set_to_player(p):
	player = p

func _physics_process(_delta):
	if player == null:
		return
	
	var vec_to_player = player.global_position + Vector2(-6, -40) - global_position
	vec_to_player = vec_to_player.normalized()
	if can_walk:
		move_and_slide(vec_to_player * 50)


func _on_Area2D_area_entered(_area):
	health -= 1
	if health > 0:
		var vec_to_player = player.global_position + Vector2(-6, -40) - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_slide(vec_to_player * -1000)
	elif health == 0:
		can_walk = false
		$AnimationPlayer.play("morreno")
	elif health > MAX_HEALTH:
		health = MAX_HEALTH

func death():
	queue_free()
