extends CharacterBody2D

const GRAVITY:float = 18
const JUMP_VELOCITY:float = -2.5

# Scales the Heat bar's collision
var difficulty: float = 1

func _ready() -> void:
	self.scale.y = self.scale.y / difficulty

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("spacebar"):
		velocity.y = JUMP_VELOCITY

	move_and_collide(velocity)
