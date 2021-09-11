extends KinematicBody2D

enum {
	MOVE,
	DASH,
	HURT
}

export var walking_animation = true

const WALKING_SPEED = 500
const DASH_SPEED = 1500
const MAX_HEALTH = 3

#var i = 0
var state = MOVE
var velocity : = Vector2.ZERO
var dash_vector : = Vector2.DOWN
var health = 3

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationState = animationtree.get("parameters/playback")

func _ready():
	get_tree().call_group("enemies", "set_to_player", self)

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		DASH:
			dash(delta)
		HURT:
			hurting()

func move_state(_delta):
	#Recebe as direções
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	#Normaliza os vetores
	if velocity.x != 0 and velocity.y != 0:
		velocity = velocity/1.414

	if walking_animation:
		#Controla as animações de movimentação
		if velocity != Vector2.ZERO:
			dash_vector = velocity
			animationtree.set("parameters/Run/blend_position", velocity)
			animationtree.set("parameters/Idle/blend_position", velocity)
			animationtree.set("parameters/Attack/blend_position", velocity)
			animationState.travel("Run")
		else:
			animationState.travel("Idle")

		#Controla a animação de ataque
		if Input.is_action_just_pressed("attack"):
			walking_animation = false
			animationState.travel("Attack")

		#Alterna para a função de dash
		elif Input.is_action_just_pressed("dash"):
			state = DASH

	#Controla o movimento do personagem
	velocity = move_and_slide(WALKING_SPEED * velocity)

#Controla o comando de dash
func dash(delta):
	animationState.travel("dashu")
	move_and_collide(DASH_SPEED * dash_vector * delta)
	
	#esse código tá uma merda tlgd pprt
	#i += 1
		
	#if i == 10:
		#i = 0
		#state = MOVE

#Alterna para a função de movimento/ataque
func dash_animation_over():
	state = MOVE

func hurting():
	animationplayer.play("im_joking")

func hurt_is_over():
	state = MOVE

func _on_Hurtbox_area_entered(area):
	health -= 1
	
	if health > 0:
		state = HURT
	elif health == 0:
		queue_free()
	elif health > 3:
		health = MAX_HEALTH

#Teste Alteracao Remota UiUi



